import 'dart:convert';
import 'package:http/http.dart' as http;

class TimeService {
  Future<String> getTime(String timezone) async {
    try {
      final res = await http.get(
        Uri.parse("https://timeapi.io/api/Time/current/zone?timeZone=$timezone"),
      );

      final data = jsonDecode(res.body);

      final time = data['time']; // format HH:mm:ss

      final hour = int.parse(time.substring(0, 2));
      final minute = time.substring(3, 5);

      final period = hour >= 12 ? "PM" : "AM";
      final hour12 = hour % 12 == 0 ? 12 : hour % 12;

      return "${hour12.toString().padLeft(2, '0')}:$minute $period";
    } catch (e) {
      return "--:--";
    }
  }

  Future<Map<String, String>> getWorldTimes() async {
    final Map<String, String> result = {};

    final cities = {
      "Jakarta (WIB)": "Asia/Jakarta",
      "Makassar (WITA)": "Asia/Makassar",
      "Jayapura (WIT)": "Asia/Jayapura",
      "New York": "America/New_York",
      "London": "Europe/London",
      "Paris": "Europe/Paris",
      "Tokyo": "Asia/Tokyo",
    };

    for (var entry in cities.entries) {
      final time = await getTime(entry.value);
      result[entry.key] = time;
    }

    return result;
  }
}