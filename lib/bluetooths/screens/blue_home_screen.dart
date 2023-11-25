import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:medicalapp/bluetooths/screens/check_health_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import '../utils/BackgroundCollectingTask.dart';
import 'select_bonded_device_screen.dart';

// import './helpers/LineChart.dart';

class BlueHomeScreen extends StatefulWidget {
  const BlueHomeScreen({super.key});

  @override
  _BlueHomeScreen createState() => _BlueHomeScreen();
}

class _BlueHomeScreen extends State<BlueHomeScreen> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask? _collectingTask;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // 화면의 높이
    double width = MediaQuery.of(context).size.width; // 화면의 가로
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[600],
        title: const Text('일일 자가 진단'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            const Divider(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  '진단 가능 기기 찾기',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
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
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(24.0),
                    color: Colors.teal[100],
                    child: InkWell(
                      splashColor: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      onTap: () async {
                        final BluetoothDevice? selectedDevice =
                            await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const SelectBondedDevicePage(
                                  checkAvailability: false);
                            },
                          ),
                        );

                        if (selectedDevice != null) {
                          print(
                              'Connect -> selected ${selectedDevice.address}');
                          _startCheck(context, selectedDevice);
                        } else {
                          print('Connect -> no device selected');
                        }
                      },
                      child: SizedBox(
                        height: height * 0.06,
                        width: width * 0.6,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "장치 검색",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startCheck(BuildContext context, BluetoothDevice device) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CheckHealthScreen(device: device);
        },
      ),
    );
  }
}
