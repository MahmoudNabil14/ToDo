import 'package:first_flutter_app/layout/home_layout/home_screen.dart';
import 'package:first_flutter_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  static String sound = 'notification_alarm.mp3';

  static BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  static initializeNotification() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('tox_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        selectNotificationSubject.add(payload!);
      },
    );
    _configureSelectNotificationSubject();
  }

  static displayNotification(String title) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id1', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.max);
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      "New task added successfully",
      title,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  static scheduledNotification(
      DateTime dateTime, String title, String description) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      "You have to get up to do your task: $title",
      description,
      scheduledDateGenerator(dateTime),
      NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            sound: RawResourceAndroidNotificationSound(sound.split('.').first),
            enableVibration: true,
            priority: Priority.max),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'title|description',
    );
  }

  static scheduledDateGenerator(DateTime dateTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, dateTime.year,
        dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      selectNotificationSubject.add(payload);
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
  }

  static void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await MyApp.navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    });
  }
}
