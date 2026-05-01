import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String _channelId = 'artesia_favorite_channel';
  static const String _channelName = 'Artesia Favorites';
  static const String _channelDescription =
      'Notifikasi saat artwork ditambahkan atau dihapus dari favorit';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);

    final macosPlugin = _plugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
    await macosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> showFavoriteNotification({
    required bool isFavorite,
    required String artworkTitle,
  }) async {
    await instance._showFavoriteNotification(
      isFavorite: isFavorite,
      artworkTitle: artworkTitle,
    );
  }

  Future<void> _showFavoriteNotification({
    required bool isFavorite,
    required String artworkTitle,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    await _requestPermissions();

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Artesia',
      playSound: true,
      enableVibration: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    final body = isFavorite
        ? 'Ditambahkan ke favorit: $artworkTitle'
        : 'Dihapus dari favorit: $artworkTitle';

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(2147483647),
      'Artesia',
      body,
      notificationDetails,
      payload: artworkTitle,
    );
  }

  void _onNotificationTap(NotificationResponse response) {}
}
