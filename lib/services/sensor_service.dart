import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class SensorService {
  StreamSubscription? _gyroSubscription;

  Function(double x, double y)? onUpdate;

  void startGyroscope() {
    _gyroSubscription = gyroscopeEvents.listen((event) {
      if (onUpdate != null) {
        onUpdate!(event.x, event.y);
      }
    });
  }

  void stop() {
    _gyroSubscription?.cancel();
  }
}