import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

class BCMNotification {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const logTag = "[BCMNotification]";

    tz_data.initializeTimeZones();
    debugPrint("$logTag 🕒 Timezone initialized: ${tz.local.name}");

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint(
            "$logTag Notification tapped → Payload: ${response.payload}");
        if (response.payload != null) {
          _handleTap(response.payload!);
        }
      },
    );

    debugPrint("$logTag ✅ Notification service initialized.");

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static void _handleTap(String payload) {
    try {
      final data = jsonDecode(payload);
      final screen = data['screen'];
      // Example: open a screen
      if (screen == 'taskDetails') {
        final taskId = data['taskId'];
        // Get.to(() => TaskDetailsPage(id: taskId)); // You can implement this
        debugPrint("[BCMNotification] Navigate to Task ID: $taskId");
      }
    } catch (_) {
      debugPrint("[BCMNotification] ⚠️ Invalid payload: $payload");
    }
  }

  static Future<void> notifyNow({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const logTag = "[BCMNotification]";

    const androidDetails = AndroidNotificationDetails(
        'todo_channel', 'To-Do Reminders',
        channelDescription: 'Reminder notifications for tasks',
        importance: Importance.max,
        priority: Priority.high,
        icon: 'icon2'
        // largeIcon: DrawableResourceAndroidBitmap('icon2')
        );

    final platformDetails = NotificationDetails(android: androidDetails);

    debugPrint("$logTag ⏰ Showing immediate notification → $title");
    await _plugin.show(id, title, body, platformDetails, payload: payload);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    print('The schedule date is $scheduledDate');
    print(
        'The schedule date for timezone is ${tz.TZDateTime.from(scheduledDate, tz.local)}');
    final String notificationTitle = "⏰ Reminder";

    await _plugin.zonedSchedule(
      id,
      notificationTitle,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          channelDescription: 'Channel for task reminders',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: BigTextStyleInformation(''),
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
    debugPrint("[BCMNotification] ❌ Canceled notification with ID $id");
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
    debugPrint("[BCMNotification] 🧹 All notifications canceled.");
  }
}
