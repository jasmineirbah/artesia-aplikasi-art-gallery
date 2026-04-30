import 'package:flutter/material.dart';
import 'package:artesia_aplikasi_art_gallery/views/auth/login_page.dart';
import 'package:artesia_aplikasi_art_gallery/views/main/main_page.dart';
import 'package:artesia_aplikasi_art_gallery/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artesia',
      debugShowCheckedModeBanner: false,

      // THEME
      theme: AppTheme.lightTheme,

      // HALAMAN AWAL
      initialRoute: '/login',

      // 
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MainPage(),
      },
    );
  }
}