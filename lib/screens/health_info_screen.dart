import 'package:flutter/material.dart';
import 'package:medicalapp/http/duration.dart';

class HealthInfoScreen extends StatelessWidget {
  List<String> title = ["질환명", "정의", "원인", "증상", "진단", "치료", "경과", "주의사항"];
  var info = [];

  HealthInfoScreen(this.info, {super.key});

  @override
  Widget build(BuildContext context) {
    int num = 0;
    double height = MediaQuery.of(context).size.height; // 화면의 높이
    double width = MediaQuery.of(context).size.width; // 화면의 가로
    Duration().sendDataToJSP(info[0]);

    for (int i = 0; i < info.length; i++) {
      info[i] = info[i].replaceAll(RegExp(r'(?<=\D)\.\s|\.(?=\d)'), '.\n');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(info[0]),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            for (String dis in info)
              if (dis != 'null')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title[num++],
                            style: const TextStyle(fontSize: 20)),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(dis),
                        SizedBox(
                          height: height * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
      // body: ListView(
      //   children: <Widget>[
      //     for (String a in info)
      //       if (a != '\r\n') Text('$a\n')
      //   ],
      // )
    );
  }
}
