import 'package:first_flutter_app/modules/new_task_screen.dart';
import 'package:first_flutter_app/modules/postponed_task_screen.dart';
import 'package:first_flutter_app/shared/constants.dart';
import 'package:first_flutter_app/shared/notification_manager.dart';
import 'package:first_flutter_app/shared/state_manager/main_cubit/main_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../../../modules/done_task_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class MainCubit extends Cubit<AppStates> {
  MainCubit() : super(AppInitialState());

  static MainCubit get(context) => BlocProvider.of(context);

  late Database database;
  AudioCache player = new AudioCache();
  static AudioPlayer audioPlayer = AudioPlayer();

  int currentIndex = 0;
  int taskId = 1;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var descriptionController = TextEditingController();
  var titleKey = GlobalKey<FormState>();
  var timeKey = GlobalKey<FormState>();
  var dateKey = GlobalKey<FormState>();
  var notificationDate;
  var notificationTime;
  late DateTime notificationDateTime;
  bool isBottomSheetShown = false;
  bool soundSwitchIsOn = false;
  String soundListValue = 'Alarm 1';
  static int? reminderValue;
  static bool? fromNotification = false;

  List<Widget> screens = [
    NewTask(),
    DoneTask(),
    PostponedTask(),
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> postponedTasks = [];


  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavIndexState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT, description TEXT, alarmSound TEXT)')
            .then((value) {
          print('table created');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppGetDatabaseState());
    });
  }

  void insertToDatabase({
    required String title,
    required String date,
    required String time,
    required String description,
    required BuildContext context,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title ,date ,time ,status ,description) VALUES("$title", "$date", "$time", "new", "$description")')
          .then((value) {
        print('$value inserted successfully');
        taskId = value;
        notificationDateTime =
            DateTime.parse("${notificationDate}T$notificationTime");
        NotificationManager.scheduledNotification(
          id: taskId,
          title: titleController.text,
          context: context,
          dateTime: notificationDateTime,
          description: descriptionController.text,
        );
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when inserting new row ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    postponedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          postponedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateTaskStatus({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      "UPDATE tasks SET status = ? WHERE id = ?",
      ['$status', id],
    ).then((value) {
      if (status == 'done' || status == 'postponed') {
        NotificationManager.cancelNotification(id);
      }
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void updateTaskData({
    required int id,
    String? title,
    String? time,
    String? date,
    String? description,

  }) async {
    database.rawUpdate(
      "UPDATE tasks SET title = ?,time = ?,date = ?,description = ? WHERE id = ?",
      [title, time, date, description, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteTasks({required DeletedTasks deletedTasks, int? id, String? status}) async {
    if(deletedTasks == DeletedTasks.ALL){
     await database
          .rawDelete(
        'DELETE FROM tasks',
      )
          .then((value) {
        NotificationManager.cancelAllNotification();
        getDataFromDatabase(database);
      });
    }
    else if(deletedTasks == DeletedTasks.ONE_TASK){
     await database
          .rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        ['$id'],
      )
          .then((value) {
        NotificationManager.cancelNotification(id!);
        getDataFromDatabase(database);
      });
    }
    else{
      database
          .rawDelete(
        'DELETE FROM tasks WHERE status = ?',
        ['$status'],
      )
          .then((value) async {
        await database.rawQuery('SELECT * FROM tasks WHERE status = ?',['$status']).then((value) {
          value.forEach((element) {
            NotificationManager.cancelNotification(element['id'] as int);
          });
        });
        getDataFromDatabase(database);
      });
    }

  }


  void changeBottomSheetState({required bool isShow}) {
    isBottomSheetShown = isShow;
    emit(AppChangeBottomSheetState());
  }

  void changeSoundSwitchButton({required bool isOn}) {
    soundSwitchIsOn = isOn;
    emit(AppSwitchState());
  }

  void changeSoundListValue({required String value}) {
    soundListValue = value;
    emit(AppListValueState());
  }

  void changeReminderListValue({int? value}) {
    reminderValue = value;
    emit(AppListValueState());
  }

  void showReminder() {
    emit(AppListValueState());
  }

}
