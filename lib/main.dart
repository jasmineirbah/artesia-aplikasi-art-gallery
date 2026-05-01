import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/session_service.dart';
import 'views/auth/login_page.dart';
import 'views/main/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkLogin() async {
    final user = await SessionService().getUser();
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkLogin(),
        builder: (context, snapshot) {
          /// 🔥 loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          /// 🔥 kalau sudah login
          if (snapshot.data == true) {
            return const MainPage();
          }

          /// 🔥 kalau belum login
          return const LoginPage();
        },
      ),
    );
  }
}