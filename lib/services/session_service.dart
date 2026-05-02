import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _userKey = 'logged_in_user';
  static const _userIdKey = 'user_id';

  Future<void> saveUser(int id, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, id);
    await prefs.setString(_userKey, username);
  }

  /// 🔥 TAMBAH INI (YANG HILANG)
  Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_userIdKey); // 🔥 sekalian benerin
  }
}