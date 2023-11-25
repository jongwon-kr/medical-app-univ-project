import 'package:medicalapp/http/ip.dart';
import 'package:http/http.dart' as http;

class Ranking {
  List<String> temp = [];

  var url = Uri.parse(
      "${"http://${IP().getIp()}"}:8080/capstoneServer/webapp/ranking.jsp");

  Map<String, String> headers = {
    'Content-Type': 'applicaiton/json',
    'Accept': 'application/json',
  };

  Map<String, String> cookies = {};

  Future<String> sendDataToJSP() async {
    String rank = '';
    var response = await http.post(
      url,
      body: {'start': "start"}, // diseaseName = 질병명임 | 질병명을 보내서 duration값을 1올림
    );

    if (response.statusCode == 200) {
      rank = response.body;
      // rank = response.body.split("㉾");
    } else {
      print('Failed to send data!');
    }
    return rank;
  }
}
