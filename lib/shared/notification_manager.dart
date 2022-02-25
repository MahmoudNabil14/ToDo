import 'package:first_flutter_app/layout/main_layout/main_layout.dart';
import 'package:first_flutter_app/main.dart';
import 'package:first_flutter_app/shared/state_manager/app_cubit/app_cubit.dart';
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

  static displayNotification({required int id, required String title}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel 0', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.max);
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id,
      "New task added successfully",
      title,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  static scheduledNotification(
      {required int id,
      required DateTime dateTime,
      required String title,
      required String description,
      required BuildContext context}) async {
    String channelId = AppCubit.get(context).soundSwitchIsOn
        ? 'channel${AppCubit.get(context).soundListValue.split('.').first}'
        : "channel2";
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      "You have to get up to do your task: $title",
      "$description",
      scheduledDateGenerator(dateTime),
      NotificationDetails(
        android: AndroidNotificationDetails(channelId, 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            sound: AppCubit.get(context).soundSwitchIsOn
                ? RawResourceAndroidNotificationSound(
                    AppCubit.get(context).soundListValue.split('.').first)
                : null,
            enableVibration: true,
            priority: Priority.max),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'title|description',
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      "You have upcoming task after 15 minutes: $title",
      "$description",
      reminderDateGenerator(dateTime),
      NotificationDetails(
        android: AndroidNotificationDetails("channel2", 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
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
      scheduledDate = scheduledDate.add(const Duration(hours: 1));
    }
    return scheduledDate;
  }

  static reminderDateGenerator(DateTime dateTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime remainderDate = tz.TZDateTime(tz.local, dateTime.year,
        dateTime.month, dateTime.day, dateTime.hour, dateTime.minute - 15);
    if (remainderDate.isBefore(now)) {
      remainderDate = remainderDate.add(const Duration(hours: 1));
    }
    return remainderDate;
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
          MaterialPageRoute(builder: (context) => MainLayout()),
          (route) => false);
    });
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
