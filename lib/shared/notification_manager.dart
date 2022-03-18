import 'package:first_flutter_app/shared/state_manager/main_cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static late tz.TZDateTime remainderDate;

  static BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  static initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject();
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
      "${AppLocalizations.of(context)!.notificationTitle}",
      title,
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
    if(MainCubit.reminderValue!=null)
    if (tz.TZDateTime(tz.local, dateTime.year, dateTime.month, dateTime.day,
                    dateTime.hour, dateTime.minute)
                .difference(tz.TZDateTime.now(tz.local)) >
            Duration(minutes: MainCubit.reminderValue!) ||
        tz.TZDateTime(tz.local, dateTime.year, dateTime.month, dateTime.day,
                dateTime.hour, dateTime.minute)
            .isBefore(tz.TZDateTime.now(tz.local))) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        1000000 + id,
        "${AppLocalizations.of(context)!.reminderNotificationTitle(MainCubit.reminderValue.toString())}",
        title,
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
        payload: '$title|$description',
      );
    }
  }

  static scheduledDateGenerator(DateTime dateTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, dateTime.year,
        dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
    print("now $now");
    print('scheduled $scheduledDate');
    return scheduledDate;
  }

  static reminderDateGenerator(DateTime dateTime) {
    remainderDate = tz.TZDateTime(tz.local, dateTime.year, dateTime.month,
        dateTime.day, dateTime.hour, dateTime.minute - MainCubit.reminderValue!);
    return remainderDate;
  }

  static void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload)  async {
      MainCubit.fromNotification = true;
    });
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(1000000 + id);
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static void cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
