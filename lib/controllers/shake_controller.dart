import '../services/shake_service.dart';

class ShakeController {
  final ShakeService _service = ShakeService();

  DateTime lastShake = DateTime.now();

  void start(void Function() onShakeDetected) {
    _service.onShake = () {
      final now = DateTime.now();

      /// 🔥 anti spam
      if (now.difference(lastShake).inMilliseconds < 800) return;

      lastShake = now;

      onShakeDetected();
    };

    _service.start();
  }

  void dispose() {
    _service.stop();
  }
}