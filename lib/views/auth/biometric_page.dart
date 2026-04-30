import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../main/main_page.dart';
import '../../widgets/app_logo.dart';

class BiometricPage extends StatefulWidget {
  const BiometricPage({super.key});

  @override
  State<BiometricPage> createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const AppLogo(),
      ),

      body: Center(
        child: GestureDetector(
          onTap: () async {
            print("CLICKED BIOMETRIC");

            bool success = await _authController.loginWithBiometric();

            print("RESULT: $success");

            if (success) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Biometric gagal"),
                ),
              );
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.fingerprint, size: 70),
              SizedBox(height: 16),
              Text(
                "Tap to verify your identity",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}