import 'package:first_flutter_app/modules/archived_task_screen.dart';
import 'package:first_flutter_app/modules/new_task_screen.dart';
import 'package:first_flutter_app/shared/notification_manager.dart';
import 'package:first_flutter_app/shared/state_manager/main_cubit/main_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../../../modules/done_task_screen.dart';

class MainCubit extends Cubit<AppStates> {
  MainCubit() : super(AppInitialState());

  static MainCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  int taskId = 1;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var descriptionController = TextEditingController();
  late DateTime notificationDateTime;
  var formKey = GlobalKey<FormState>();

  List<Widget> screens = [
    NewTask(),
    DoneTask(),
    ArchivedTask(),
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  late Database database;

  bool isBottomSheetShown = false;
  bool soundSwitchIsOn = false;
  var soundListValue = 'basic_alarm.mp3';

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
        emit(AppGetDatabaseState());
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void insertToDatabase(
      {required String title,
      required String date,
      required String time,
      required String description,
      required BuildContext context}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title ,date ,time ,status ,description) VALUES("$title", "$date", "$time", "new", "$description")')
          .then((value) {
        print('$value inserted successfully');
        taskId = value;
        notificationDateTime =
            DateTime.parse("${dateController.text}T${timeController.text}");
        print(taskId);
        NotificationManager.displayNotification(
            id: taskId, title: titleController.text);
        NotificationManager.scheduledNotification(
            id: taskId,
            title: titleController.text,
            context: context,
            dateTime: notificationDateTime,
            description: descriptionController.text);
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
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void getTaskByTitle(database, String title) {
    var task;
    database.rawQuery('SELECT FROM tasks WHERE title = ?', ['$title']).then(
        (value) {
      task = value;
    });
    return (task);
  }

  void updateTaskStatus({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      "UPDATE tasks SET status = ? WHERE id = ?",
      ['$status', id],
    ).then((value) {
      emit(AppChangeState());
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void updateTaskData({
    required String description,
    required int id,
  }) async {
    database.rawUpdate(
      "UPDATE tasks SET description = ? WHERE id = ?",
      ['$description', id],
    ).then((value) {
      emit(AppChangeState());
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      ['$id'],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
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
}
