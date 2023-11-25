import 'package:flutter/material.dart';
import 'package:medicalapp/http/dictionaryInfo.dart';
import 'package:medicalapp/http/ranking.dart';
import 'package:medicalapp/screens/health_info_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> diseases = <String>[];

List<String> parts = <String>[
  "가슴",
  "골반",
  "귀",
  "기타",
  "눈",
  "다리",
  "등/허리",
  "머리",
  "목",
  "발",
  "배",
  "생식기",
  "손",
  "얼굴",
  "엉덩이",
  "유방",
  "입",
  "전신",
  "코",
  "팔",
  "피부"
];
late SharedPreferences prefs;
List<String> recent = [];

class DicionaryScreen extends StatefulWidget {
  const DicionaryScreen({super.key});

  @override
  State<DicionaryScreen> createState() => _DicionaryScreenState();
}

class _DicionaryScreenState extends State<DicionaryScreen> {
  void checkPrefs() async {
    prefs = await SharedPreferences.getInstance();
    String? temp = prefs.getString('recent');

    if (temp != null) {
      print(temp);
      recent = temp.split('\n');
    }
  }

  SizedBox myBox = const SizedBox();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // 화면의 높이
    double width = MediaQuery.of(context).size.width; // 화면의 가로

    checkPrefs();

    // List<String> pokeywords = <String>[];
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      key: scaffoldKey,
      drawer: const MainDrawer(),
      // 상단 메뉴바, 제목, 검색관련 컨테이너
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.teal[500],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.zero,
                height: height * 0.35,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.07,
                    ),
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    scaffoldKey.currentState?.openDrawer();
                                  },
                                  icon: const Icon(
                                    Icons.menu,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.023,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: width * 0.22,
                            ),
                            Column(
                              children: [
                                const Text(
                                  '질환백과',
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  'dictionary of diseases',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    // 검색 바
                    Padding(
                      padding: const EdgeInsets.all(
                        15,
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HealthInfoListScreen('', value)));
                          if (recent.contains(value)) {
                            recent.remove(value);
                          }

                          recent.add(value);

                          String temp = '';
                          for (String str in recent) {
                            temp += '\n$str';
                          }
                          prefs.setString('recent', temp);
                          setState(() {
                            myBox = newMethod(context, height, width, false);
                          });
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          iconColor: Colors.white,
                          hintStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          hintText: 'Type a keyword',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 13),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(24.0),
                                color: Colors.teal[700],
                                child: InkWell(
                                  splashColor: Colors.teal[200],
                                  borderRadius: BorderRadius.circular(24.0),
                                  onTap: () {
                                    fetchData().then((data) {
                                      Future<String> rank;
                                      String r;
                                      rank = Ranking().sendDataToJSP();

                                      rank.then(
                                        (String value) {
                                          r = value;
                                          r = r.replaceAll(
                                              RegExp('[\r\n]'), "");
                                          diseases = r.split("㉾");

                                          setState(() {
                                            myBox = newMethod(
                                                context, height, width, true);
                                          });
                                        },
                                      );
                                    });
                                  },
                                  child: SizedBox(
                                    height: height * 0.045,
                                    width: width * 0.45,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "많이 찾는 질환",
                                          style: TextStyle(
                                              color: Colors.teal[50],
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(24.0),
                                color: Colors.teal[900],
                                child: InkWell(
                                  splashColor: Colors.teal[200],
                                  borderRadius: BorderRadius.circular(24.0),
                                  onTap: () {
                                    setState(() {
                                      myBox = newMethod(
                                          context, height, width, false);
                                    });
                                  },
                                  child: SizedBox(
                                    height: height * 0.045,
                                    width: width * 0.45,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "최근 검색 기록",
                                          style: TextStyle(
                                              color: Colors.teal[50],
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
                  ],
                ),
              ),
              // 경계 아래 부분
              myBox,
            ],
          ),
        ),
      ),
    );
  }

  Future<String> fetchData() async {
    Future<String> rank;
    rank = Ranking().sendDataToJSP();

    return rank;
  }

  SizedBox newMethod(BuildContext context, height, double width, bool tf) {
    List<String> stemp = recent;
    stemp = stemp.toSet().toList();
    stemp = List.from(stemp.reversed);
    SizedBox sb = const SizedBox();
    if (tf) {
      sb = SizedBox(
        height: height * 0.65,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.04,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * 0.03,
                    ),
                    const Text(
                      '많이 찾는 질환',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              for (String disease in diseases)
                if (disease != '')
                  poKeyword(context, disease, height, width, tf),
              SizedBox(
                height: height * 0.095,
              )
            ],
          ),
        ),
      );
    } else {
      sb = SizedBox(
        height: height * 0.65,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: height * 0.04,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          '최근 검색어',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: width * 0.5,
                        ),
                        TextButton(
                          onPressed: () {
                            prefs.clear();
                            recent = [];
                            setState(() {
                              myBox = newMethod(context, height, width, tf);
                            });
                          },
                          child: const Text('모두지우기',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              for (String str in stemp)
                if (str != '') poKeyword(context, str, height, width, tf),
              SizedBox(
                height: height * 0.095,
              )
            ],
          ),
        ),
      );
    }
    return sb;
  }

  Container poKeyword(BuildContext context, String disease, double height,
      double width, bool tf) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.4)),
        ),
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.grey,
          onTap: () {
            if (tf) {
              DictionaryInfo().sendDataToJSP(context, disease);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HealthInfoListScreen('', disease)));
              if (recent.contains(disease)) {
                recent.remove(disease);
              }
              recent.add(disease);
              String temp = '';
              for (String str in recent) {
                temp += '\n$str';
              }
              prefs.setString('recent', temp);
              setState(() {
                myBox = newMethod(context, height, width, false);
              });
            }
          },
          child: SizedBox(
            height: height * 0.0545,
            width: width,
            child: Padding(
              padding: EdgeInsets.only(left: (width * 0.01)),
              child: Row(
                mainAxisAlignment: tf
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (tf) const Icon(Icons.search),
                  if (tf)
                    const SizedBox(
                      width: 10,
                    ),
                  tf
                      ? Flexible(
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: disease,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            const Icon(Icons.search),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              disease,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                  if (!tf)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        recent.remove(disease);
                        String temp = '';
                        for (String str in recent) {
                          temp += '\n$str';
                        }
                        prefs.setString('recent', temp);
                        setState(() {
                          myBox = newMethod(context, height, width, tf);
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// drawer
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // 화면의 높이
    return Drawer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const ListTile(
            title: Text(
              "부위별 질환 검색",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.w800),
            ),
          ),
          for (String part in parts) drawerMenu(context, part),
        ],
      ),
    );
  }

  ListTile drawerMenu(BuildContext context, menuName) {
    return ListTile(
      shape: const Border(bottom: BorderSide(color: Colors.grey)),
      splashColor: Colors.teal[100],
      trailing: Icon(
        Icons.double_arrow,
        color: Colors.teal[100],
      ),
      title: Text(
        menuName,
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HealthInfoListScreen(menuName, '')));
      },
    );
  }
}
