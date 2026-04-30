import '../services/sensor_service.dart';

class SensorController {
  final SensorService _service = SensorService();

  double targetX = 0;
  double targetY = 0;

  double offsetX = 0;
  double offsetY = 0;

  void start(void Function() updateUI) {
    _service.onUpdate = (x, y) {
      /// 🎯 target dari sensor
      targetX = y * 30;
      targetY = x * 30;

      /// 🎯 smoothing (lerp)
      offsetX += (targetX - offsetX) * 0.1;
      offsetY += (targetY - offsetY) * 0.1;

      /// batas biar ga liar
      offsetX = offsetX.clamp(-25, 25);
      offsetY = offsetY.clamp(-25, 25);

      updateUI();
    };

    _service.startGyroscope();
  }

  void dispose() {
    _service.stop();
  }
}