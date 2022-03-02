import 'package:first_flutter_app/main.dart';
import 'package:first_flutter_app/modules/on_open_notification_screen.dart';
import 'package:first_flutter_app/shared/state_manager/main_cubit/main_cubit.dart';
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

  static late tz.TZDateTime remainderDate;
  static final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

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
        if (payload != null) {
          selectNotificationSubject.add(payload);
        }
        _configureSelectNotificationSubject();
      },
    );
  }

  static scheduledNotification({
    required int id,
    required DateTime dateTime,
    required String title,
    required String description,
    required BuildContext context,
  }) async {
    String channelId = MainCubit.get(context).soundSwitchIsOn
        ? 'channel${MainCubit.get(context).soundListValue}'
        : "channel2";
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      "You have to get up to do your task: $title",
      description.isNotEmpty?"$description":"This task has no description",
      scheduledDateGenerator(dateTime),
      NotificationDetails(
        android: AndroidNotificationDetails(channelId, 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            sound: MainCubit.get(context).soundSwitchIsOn
                ? RawResourceAndroidNotificationSound(MainCubit.get(context)
                            .soundListValue ==
                        'Alarm 1'
                    ? "alarm_1"
                    : MainCubit.get(context).soundListValue == 'Alarm 2'
                        ? 'alarm_2'
                        : MainCubit.get(context).soundListValue == 'Alarm 3'
                            ? 'alarm_3'
                            : MainCubit.get(context).soundListValue == 'Alarm 4'
                                ? 'alarm_4'
                                : MainCubit.get(context).soundListValue ==
                                        'Alarm 5'
                                    ? 'alarm_5'
                                    : MainCubit.get(context).soundListValue ==
                                            'Alarm 6'
                                        ? 'alarm_6'
                                        : MainCubit.get(context)
                                                    .soundListValue ==
                                                'Alarm 7'
                                            ? 'alarm_7'
                                            : MainCubit.get(context)
                                                        .soundListValue ==
                                                    'Alarm 8'
                                                ? 'alarm_8'
                                                : MainCubit.get(context)
                                                            .soundListValue ==
                                                        'Alarm 9'
                                                    ? 'alarm_9'
                                                    : 'alarm_10')
                : null,
            enableVibration: true,
            priority: Priority.max),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '$title|$description',
    );
    // if (tz.TZDateTime(tz.local, dateTime.year, dateTime.month, dateTime.day,
    //             dateTime.hour, dateTime.minute)
    //         .difference(now) >
    //     Duration(minutes: 15)) {
    //   await flutterLocalNotificationsPlugin.zonedSchedule(
    //     id,
    //     "You have upcoming task after 15 minutes: $title",
    //     "$description",
    //     reminderDateGenerator(dateTime),
    //     NotificationDetails(
    //       android: AndroidNotificationDetails("channel2", 'your channel name',
    //           channelDescription: 'your channel description',
    //           importance: Importance.max,
    //           enableVibration: true,
    //           priority: Priority.max),
    //     ),
    //     androidAllowWhileIdle: true,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     matchDateTimeComponents: DateTimeComponents.time,
    //     payload: '$title|$description',
    //   );
    // }
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
    remainderDate = tz.TZDateTime(tz.local, dateTime.year, dateTime.month,
        dateTime.day, dateTime.hour, dateTime.minute - 15);
    if (remainderDate.isBefore(now)) {
      remainderDate = remainderDate.add(const Duration(hours: 1));
      return remainderDate;
    }
  }

  static void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await MyApp.navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => OnOpenNotificationScreen(title:payload.split('|').first,description:payload.split('|').last,)),);
    });
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
