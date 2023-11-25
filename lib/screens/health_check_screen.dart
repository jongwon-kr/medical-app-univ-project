import 'package:flutter/material.dart';
import 'package:medicalapp/http/healthCheck.dart';
import 'package:medicalapp/screens/my_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class healthCheckScreen extends StatefulWidget {
  const healthCheckScreen({super.key});

  @override
  State<healthCheckScreen> createState() => _healthCheckScreenState();
}

class _healthCheckScreenState extends State<healthCheckScreen> {
  List<String> que = [
    "통증",
    "두통",
    "복통",
    "요통",
    "흉통",
    "기침",
    "관절통",
    "근육통",
    "통풍",
    "생리통",
    "인후통",
    "신경통",
    "관절염",
    "협심증",
    "월경통",
    "배뇨통",
    "빈뇨",
    "소화불량",
    "호흡곤란",
    "변비",
    "설사",
    "구토",
    "체중감소",
    "피로감",
    "발열",
    "오심",
    "두근거림",
    "당뇨",
    "고혈압",
    "빈혈",
    "천식",
    "부비동",
    "코",
    "어깨",
    "목",
    "팔",
    "손",
    "다리",
    "눈",
    "골반"
  ];

  int check = 0;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late bool isLogin = false;
  late User loggedInUser;
  late int point = 0;
  static List<bool> responses = [];
  String nickname = '';
  String result = "";
  late bool checkhealth = false;
  late Timestamp date = Timestamp.now();
  late bool todayCheck = false;
  late final userInfo = <String, dynamic>{
    "nickname": nickname,
  };
  late final userPoint = <String, dynamic>{
    "point": point,
  };
  late final dailyquest = <String, dynamic>{
    "checkhealth": checkhealth,
    "date": date,
  };

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
    responses = List.filled(que.length, false);
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        isLogin = true;
        _firestore
            .collection("userinfo")
            .doc(loggedInUser.email)
            .get()
            .then((value) => userInfo["nickname"] = value.data()?["nickname"]);
        _firestore
            .collection("mileages")
            .doc(loggedInUser.email)
            .get()
            .then((value) => userPoint["point"] = value.data()?["point"]);
        final quest =
            _firestore.collection("dailyquest").doc(loggedInUser.email).get();
        await quest.then((value) =>
            dailyquest["checkhealth"] = value.data()?["checkhealth"]);
        await quest.then((value) => dailyquest["date"] = value.data()?["date"]);
        setState(() {
          todayCheck = dailyquest["date"].toDate().toString().split(" ")[0] ==
              DateTime.now().toString().split(" ")[0];
        });
      } else {
        isLogin = false;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // 화면의 높이
    double width = MediaQuery.of(context).size.width; // 화면의 가로
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        titleSpacing: 10,
        backgroundColor: Colors.teal[400],
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
        ),
        leadingWidth: 10,
        title: const ListTile(
          title: Text(
            '문진',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                for (int i = 0; i < que.length; i++) buildQuestion(i, que[i]),
                IconButton(
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 40,
                    ),
                    onPressed: () async {
                      isLogin
                          ? validateAndSubmit()
                          : showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Text("로그인이 필요한 서비스 입니다."),
                                );
                              },
                            );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuestion(int index, String question) {
    return Column(
      children: [
        if (index <= 30)
          Text(
            "${index + 1}. $question 이/가 있습니까?",
            style: const TextStyle(fontSize: 18),
          ),
        if (index > 30)
          Text(
            "${index + 1}. $question 에 통증이 있습니까?",
            style: const TextStyle(fontSize: 18),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: true,
              groupValue: responses[index],
              onChanged: (value) {
                setState(() {
                  responses[index] = true;
                });
              },
            ),
            const Text("Y"),
            Radio(
              value: false,
              groupValue: responses[index],
              onChanged: (value) {
                setState(() {
                  responses[index] = false;
                });
              },
            ),
            const Text("N"),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void validateAndSubmit() {
    for (int i = 0; i < que.length; i++) {
      if (responses[i] == true) {
        result += "${que[i]},";
      }
    }
    if (result.split(",").length >= 4) {
      print(userInfo["nickname"]);
      HealthCheck().sendDataToJSP(userInfo["nickname"], result);
      //마일리지 올리기
      userPoint["point"] += 500;
      _firestore
          .collection("mileages")
          .doc(loggedInUser.email)
          .set(
            userPoint,
            SetOptions(merge: true),
          )
          .onError(
            (e, _) => print("Error:$e"),
          );
      dailyquest["checkhealth"] = true;
      dailyquest["date"] = DateTime.now();
      isLogin
          ? _firestore.collection("dailyquest").doc(loggedInUser.email).set(
                dailyquest,
                SetOptions(merge: true),
              )
          : print("not login!");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyInfoScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("증상을 3개 이상 선택해주세요"),
          );
        },
      );
    }
  }
}
