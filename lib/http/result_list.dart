import 'package:medicalapp/http/ip.dart';
import 'package:http/http.dart' as http;

class resultList {
  var url = Uri.parse(
      "${"http://${IP().getIp()}"}:8080/capstoneServer/webapp/search_result.jsp");

  Map<String, String> headers = {
    'Content-Type': 'applicaiton/json',
    'Accept': 'application/json',
  };

  Map<String, String> cookies = {};

  Future<List<String>> sendDataToJSP(String name) async {
    var response = await http.post(
      url,
      body: {
        'NM': name,
      },
    );

    if (response.statusCode == 200) {
      print("성공");
      String t = response.body;
      print("==================================================");

      t = t.replaceAll(RegExp('[\r\n]'), "");

      List<String> temp = t.split("§");

      temp[0] = temp[0].replaceAll(RegExp(r'\\'), '');

      for (String a in temp) {
        print("info = $a");
      }

      return temp;
    } else {
      List<String> fail = ["fail"];
      return fail;
    }
  }
}
