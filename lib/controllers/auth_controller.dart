import 'package:artesia_aplikasi_art_gallery/models/user_model.dart';
import 'package:artesia_aplikasi_art_gallery/services/database_service.dart';
import 'package:artesia_aplikasi_art_gallery/utils/hash_helper.dart';

class AuthController {
  AuthController({DatabaseService? databaseService})
    : _databaseService = databaseService ?? DatabaseService.instance;

  final DatabaseService _databaseService;

  String? validateFullName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Nama wajib diisi';
    }

    if (name.length < 3) {
      return 'Nama minimal 3 karakter';
    }

    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Password wajib diisi';
    }

    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    final confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }

    if (confirmPassword != password) {
      return 'Konfirmasi password tidak sama';
    }

    return null;
  }

  Future<AuthResult> register({
    required String fullName,
    required String password,
  }) async {
    final trimmedName = fullName.trim();

    try {
      final existingUser = await _databaseService.getUserByName(trimmedName);
      if (existingUser != null) {
        return const AuthResult.failure('Nama sudah terdaftar.');
      }

      final user = UserModel(
        fullName: trimmedName,
        passwordHash: HashHelper.hashPassword(password),
        createdAt: DateTime.now(),
      );

      final id = await _databaseService.createUser(user);
      return AuthResult.success('Akun berhasil dibuat.', user.copyWith(id: id));
    } catch (_) {
      return const AuthResult.failure(
        'Database SQLite belum siap di platform ini.',
      );
    }
  }

  Future<AuthResult> login({
    required String fullName,
    required String password,
  }) async {
    final trimmedName = fullName.trim();

    try {
      final user = await _databaseService.getUserByName(trimmedName);

      if (user == null) {
        return const AuthResult.failure('Nama belum terdaftar.');
      }

      final isPasswordValid = HashHelper.verifyPassword(
        password: password,
        passwordHash: user.passwordHash,
      );

      if (!isPasswordValid) {
        return const AuthResult.failure('Password salah.');
      }

      final userId = user.id;
      final loginTime = DateTime.now();
      if (userId != null) {
        await _databaseService.updateLastLogin(userId, loginTime);
      }

      return AuthResult.success(
        'Login berhasil.',
        user.copyWith(lastLoginAt: loginTime),
      );
    } catch (_) {
      return const AuthResult.failure(
        'Database SQLite belum siap di platform ini.',
      );
    }
  }
}

class AuthResult {
  const AuthResult._({
    required this.isSuccess,
    required this.message,
    this.user,
  });

  const AuthResult.success(String message, UserModel user)
    : this._(isSuccess: true, message: message, user: user);

  const AuthResult.failure(String message)
    : this._(isSuccess: false, message: message);

  final bool isSuccess;
  final String message;
  final UserModel? user;
}
