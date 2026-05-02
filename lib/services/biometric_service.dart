import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      bool canCheck = await auth.canCheckBiometrics;
      print("CAN CHECK: $canCheck");

      if (!canCheck) return false;

      final available = await auth.getAvailableBiometrics();
      print("AVAILABLE: $available");

      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to login',
        options: const AuthenticationOptions(
          biometricOnly: false, 
          stickyAuth: true,     
        ),
      );

      print("AUTH RESULT: $isAuthenticated");

      return isAuthenticated;
    } catch (e) {
      print("ERROR BIOMETRIC: $e");
      return false;
    }
  }
}