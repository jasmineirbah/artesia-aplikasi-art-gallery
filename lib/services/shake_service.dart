import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class ShakeService {
  StreamSubscription? _subscription;

  Function()? onShake;

  void start() {
    _subscription = accelerometerEvents.listen((event) {
      double x = event.x;
      double y = event.y;
      double z = event.z;

      double total = (x * x + y * y + z * z);

      if (total > 200) {
        if (onShake != null) onShake!();
      }
    });
  }

  void stop() {
    _subscription?.cancel();
  }
}