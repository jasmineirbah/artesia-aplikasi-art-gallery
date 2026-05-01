import 'dart:convert';
import 'package:http/http.dart' as http;

class TimeService {
  Future<String> getTime(String timezone) async {
    try {
      final res = await http.get(
        Uri.parse("http://worldtimeapi.org/api/timezone/$timezone"),
      );

      final data = jsonDecode(res.body);
      final datetime = data['datetime'];

      return datetime.substring(11, 16);
    } catch (e) {
      return "--:--";
    }
  }
}