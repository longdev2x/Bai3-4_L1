import 'package:exercies3/features/application/view/application.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize1() async {
    tz.initializeTimeZones();
    await _requestNotificationPermission();
  }

  Future<void> initialize2(BuildContext context) async {
    //Khởi tạo notify plugin phía local, và xử lý onTap to notify
    _setupNotification(context);
  }

  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
    if (kDebugMode) {
      print('Người dùng đã : ${settings.authorizationStatus}');
    }
  }

  void _setupNotification(BuildContext context) async {
    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => const Application(),), (route) => false,);
      },
    );
  }
  Future<void> scheduleSleepNotification(
      String channelId,
      String channelName,
      String title,
      String body,
      String payload,
      TimeOfDay time) async {

    final vietnamTime = tz.getLocation('Asia/Ho_Chi_Minh');
    final now = tz.TZDateTime.now(vietnamTime);

    var scheduledDate = tz.TZDateTime(
      vietnamTime,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      importance: Importance.max,
    );

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: channel.importance,
            priority: Priority.high,
            icon: '@drawable/notification_icon',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
      if (kDebugMode) {
        print("zzzĐã lên lịch thông báo thành công");
      }
    } catch (e) {
      if (kDebugMode) {
        print("zzzLỗi khi lên lịch thông báo: $e");
      }
    }
  }
}
