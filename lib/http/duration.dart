import 'package:medicalapp/http/ip.dart';
import 'package:http/http.dart' as http;

class Duration {
  var url = Uri.parse(
      "${"http://${IP().getIp()}"}:8080/capstoneServer/webapp/duration.jsp");

  Map<String, String> headers = {
    'Content-Type': 'applicaiton/json',
    'Accept': 'application/json',
  };

  Map<String, String> cookies = {};

  Future<void> sendDataToJSP(String dName) async {
    var response = await http.post(
      url,
      body: {'dName': dName}, // diseaseName = 질병명임 | 질병명을 보내서 duration값을 1올림
    );

    if (response.statusCode == 200) {
      // 필요없음 값을 1 올리는 용도의 통신
    } else {
      // 전송 실패 시 처리할 내용을 작성해주세요
      print('Failed to send data!');
    }
  }
}
