import 'package:medicalapp/http/ip.dart';
import 'package:http/http.dart' as http;
//import 'package:medicalapp/widget/result_list.dart';

class HealthCheck {
  var url = Uri.parse(
      "${"http://${IP().getIp()}"}:8080/capstoneServer/webapp/quedb.jsp");

  Map<String, String> headers = {
    'Content-Type': 'applicaiton/json',
    'Accept': 'application/json',
  };

  Map<String, String> cookies = {};

  Future<void> sendDataToJSP(String name, String result) async {
    List<String> temp = [];
    var response = await http.post(
      url,
      body: {
        'NM': name,
        'RT': result,
      },
    );

    if (response.statusCode == 200) {
      print("성공");
    } else {
      List<String> fali_msg = ["Failde to send data"];
      print('Failed to send data!');
    }
  }
}
