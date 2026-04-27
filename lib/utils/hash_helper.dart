import 'dart:convert';

import 'package:crypto/crypto.dart';

class HashHelper {
  static const _salt = 'artesia_local_auth_v1';

  static String hashPassword(String password) {
    final bytes = utf8.encode('$_salt:$password');
    return sha256.convert(bytes).toString();
  }

  static bool verifyPassword({
    required String password,
    required String passwordHash,
  }) {
    return hashPassword(password) == passwordHash;
  }
}
