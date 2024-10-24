import 'package:example/res/res.dart';
import 'package:flutter/foundation.dart';
// #1
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNoticeService {
  LocalNoticeService._internal();

  factory LocalNoticeService() => _notificationService;

  // Singleton of the LocalNoticeService
  static final LocalNoticeService _notificationService =
      LocalNoticeService._internal();

  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  Future<void> setup() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting =
        DarwinInitializationSettings(requestSoundPermission: true);

    const initSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _localNotificationsPlugin
        .initialize(
      initSettings,
    )
        .then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  void showFlutterNotification(
    String title,
    String body,
  ) {
    _localNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        iOS: const DarwinNotificationDetails(
          presentBadge: true,
          presentAlert: true,
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description ?? '',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          playSound: true,
          icon: '@mipmap/ic_launcher',
          color: ColorsValue.primaryColorLight,
        ),
      ),
    );
  }

  void cancelAllNotification() {
    _localNotificationsPlugin.cancelAll();
  }
}
