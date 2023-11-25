import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:medicalapp/screens/home_screen.dart';

class CheckHealthScreen extends StatefulWidget {
  const CheckHealthScreen({required this.device});
  final BluetoothDevice device;

  @override
  _CheckHealthScreen createState() => new _CheckHealthScreen();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _CheckHealthScreen extends State<CheckHealthScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late bool isLogin = false;
  late User loggedInUser;
  late int point = 0;

  late final userPoint = <String, dynamic>{
    "point": point,
  };

  static final clientID = 0;
  BluetoothConnection? connection;
  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;
  bool hCheck = false;
  bool gCheck = false;
  bool bCheck = false;
  bool tCheck = false;
  bool allCheck = false;

  late bool checkarduino = false;
  late Timestamp date = Timestamp.now();
  late bool todayCheck = false;

  late final hScore = <String, String>{
    "최소": "",
    "평균": "",
    "최대": "",
  };
  late final gScore = <String, String>{
    "최소": "",
    "최대": "",
  };
  late final bScore = <String, String>{
    "최소": "",
    "평균": "",
    "최대": "",
  };
  late final tScore = <String, String>{
    "외부 온도": "",
    "체온": "",
  };

  late final dailyquest = <String, dynamic>{
    "checkarduino": checkarduino,
    "date": date,
  };

  @override
  void initState() {
    getCurrentUser();
    super.initState();

    BluetoothConnection.toAddress(widget.device.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(
        () {
          isConnecting = false;
          isDisconnecting = false;
        },
      );

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error + "???");
    });
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        _firestore
            .collection("mileages")
            .doc(loggedInUser.email)
            .get()
            .then((value) => userPoint["point"] = value.data()?["point"]);
        final quest =
            _firestore.collection("dailyquest").doc(loggedInUser.email).get();
        await quest.then((value) =>
            dailyquest["checkarduino"] = value.data()?["checkarduino"]);
        await quest.then((value) => dailyquest["date"] = value.data()?["date"]);
        todayCheck = dailyquest["date"].toDate().toString().split(" ")[0] ==
            DateTime.now().toString().split(" ")[0];
        isLogin = true;

        setState(() {});
      } else {
        isLogin = false;
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // 화면의 높이
    double width = MediaQuery.of(context).size.width; // 화면의 가로
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    final deviceName = widget.device.name ?? "Unknown";
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal[600],
          title: (isConnecting
              ? Text(deviceName + ' 연결중...')
              : isConnected
                  ? Text(deviceName + ' 연결됨')
                  : Text(deviceName + ' 연결 안됨'))),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView(
                padding: const EdgeInsets.all(12.0),
                controller: listScrollController,
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: width * 0.85,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(0, 7),
                                )
                              ],
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "심전도 검사",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "최소 : " + hScore["최소"]!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "평균 : " + hScore["평균"]!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "최대 : " + hScore["최대"]!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              width: width * 0.85,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    blurRadius: 5.0,
                                    spreadRadius: 0.0,
                                    offset: const Offset(0, 7),
                                  )
                                ],
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "근전도 검사",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "최소 : " + gScore["최소"]!,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "최대 : " + gScore["최대"]!,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                ],
                              )),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: width * 0.85,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(0, 7),
                                )
                              ],
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "심박수 검사",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "최소 : " + bScore["최소"]!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "평균 : " + bScore["평균"]!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "최대 : " + bScore["최대"]!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: width * 0.85,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(0, 7),
                                )
                              ],
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "체온 검사",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "외부 온도 : " + tScore["외부 온도"]!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "체온 : " + tScore["체온"]!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5);
                                }
                                return allCheck ? Colors.teal : Colors.grey;
                              },
                            ),
                          ),
                          child: const Text('일일 자가 진단 마일리지 500 받기'),
                          onPressed: allCheck &&
                                  todayCheck &&
                                  !dailyquest["checkarduino"]
                              ? () {
                                  userPoint["point"] += 500;
                                  isLogin
                                      ? _firestore
                                          .collection("mileages")
                                          .doc(loggedInUser.email)
                                          .set(
                                            userPoint,
                                            SetOptions(merge: true),
                                          )
                                      : print("not login!");
                                  dailyquest["checkarduino"] = true;
                                  dailyquest["date"] = DateTime.now();
                                  isLogin
                                      ? _firestore
                                          .collection("dailyquest")
                                          .doc(loggedInUser.email)
                                          .set(
                                            dailyquest,
                                            SetOptions(merge: true),
                                          )
                                      : print("not login!");
                                  final snackBar = SnackBar(
                                    backgroundColor: Colors.teal[700],
                                    content: const Text(
                                      '마일리지 500 적립!!',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    action: SnackBarAction(
                                      textColor: Colors.white,
                                      label: "확인",
                                      onPressed: () {},
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              : null,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    print("receive");
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach(
      (byte) {
        if (byte == 8 || byte == 127) {
          backspacesCounter++;
        }
      },
    );
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;
    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }
    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    if (dataString.contains("#h")) {
      hScore["최대"] = dataString.split("#")[2];
      hScore["평균"] = dataString.split("#")[3];
      hScore["최소"] = dataString.split("#")[4];
      hCheck = true;
    } else if (dataString.contains("#g")) {
      gScore["최대"] = dataString.split("#")[2];
      gScore["최소"] = dataString.split("#")[3];
      gCheck = true;
    } else if (dataString.contains("#b")) {
      bScore["최대"] = dataString.split("#")[2];
      bScore["평균"] = dataString.split("#")[3];
      bScore["최소"] = dataString.split("#")[4];
      bCheck = true;
    } else if (dataString.contains("#t")) {
      tScore["외부 온도"] = dataString.split("#")[2] + "℃";
      tScore["체온"] = dataString.split("#")[3] + "℃";
      tCheck = true;
    }
    if (hCheck && gCheck && bCheck && tCheck) {
      allCheck = true;
    }
    setState(() {});
  }
}
