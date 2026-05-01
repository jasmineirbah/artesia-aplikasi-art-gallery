import '../services/time_service.dart';

class TimeController {
  final TimeService _service = TimeService();

  /// 🔥 MAP CULTURE → TIMEZONE
  String mapCultureToTimezone(String? culture) {
    if (culture == null || culture.isEmpty) {
      return "Asia/Jakarta"; // default
    }

    final c = culture.toLowerCase();

    if (c.contains("indonesia")) return "Asia/Jakarta";
    if (c.contains("japan")) return "Asia/Tokyo";
    if (c.contains("korea")) return "Asia/Seoul";
    if (c.contains("china")) return "Asia/Shanghai";
    if (c.contains("france")) return "Europe/Paris";
    if (c.contains("italy")) return "Europe/Rome";
    if (c.contains("british") || c.contains("england")) return "Europe/London";
    if (c.contains("germany")) return "Europe/Berlin";
    if (c.contains("netherlands") || c.contains("dutch")) return "Europe/Amsterdam";
    if (c.contains("spain")) return "Europe/Madrid";
    if (c.contains("usa") || c.contains("american")) return "America/New_York";

    /// 🔥 fallback kalau ga ketemu
    return "Asia/Jakarta";
  }

  /// 🔥 AMBIL 1 WAKTU SESUAI CULTURE
  Future<String> getTimeByCulture(String? culture) async {
    final timezone = mapCultureToTimezone(culture);
    return await _service.getTime(timezone);
  }

  /// 🔥 OPTIONAL (kalau kamu masih mau multi timezone)
  Future<Map<String, String>> getAllTimes() async {
    final zones = {
      "WIB": "Asia/Jakarta",
      "WITA": "Asia/Makassar",
      "WIT": "Asia/Jayapura",
      "London": "Europe/London",
      "Tokyo": "Asia/Tokyo",
    };

    Map<String, String> result = {};

    for (var entry in zones.entries) {
      final time = await _service.getTime(entry.value);
      result[entry.key] = time;
    }

    return result;
  }
}