import 'package:buildcondition/buildcondition.dart';
import 'package:first_flutter_app/layout/notification_manager.dart';
import 'package:first_flutter_app/layout/theme_cubit/theme_cubit.dart';
import 'package:first_flutter_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'app_cubit/app_cubit.dart';
import 'app_cubit/app_states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var descriptionController = TextEditingController();
  late String dateAndTime;
  var time;
  var date;
  late DateTime notificationDateTime;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(listener: (context, states) {
      if (states is AppInsertDatabaseState) {
        Navigator.pop(context);
        AppCubit.get(context).changeIndex(0);
        titleController.text = '';
        dateController.text = '';
        timeController.text = '';
        descriptionController.text = '';
      }
    }, builder: (context, states) {
      AppCubit cubit = AppCubit.get(context);
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(cubit.titles[cubit.currentIndex]),
          actions: [
            IconButton(
                tooltip: 'Change App Theme',
                onPressed: () {
                  ThemeCubit.get(context).changeAppTheme();
                  if (AppCubit.get(context).isBottomSheetShown == true)
                    Navigator.pop(context);
                },
                icon: Icon(Icons.brightness_6_outlined))
          ],
        ),
        body: BuildCondition(
          condition: true,
          builder: (BuildContext context) {
            MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true);
            return cubit.screens[cubit.currentIndex];
          },
          fallback: (BuildContext context) => CircularProgressIndicator(),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add task",
          onPressed: () {
            if (cubit.isBottomSheetShown) {
              if (formKey.currentState!.validate()) {
                cubit.insertToDatabase(
                  date: dateController.text,
                  title: titleController.text,
                  time: timeController.text,
                  description: descriptionController.text,
                );
                dateAndTime =
                    DateFormat('yyyy/MM/dd').format(date) + " " + time;
                notificationDateTime =
                    DateFormat('yyyy/MM/dd HH:mm').parse(dateAndTime);
                NotificationManager.displayNotification(titleController.text);
                NotificationManager.scheduledNotification(notificationDateTime,
                    titleController.text, descriptionController.text);
              }
            } else {
              titleController.text = '';
              timeController.text = '';
              dateController.text = '';
              descriptionController.text = '';
              scaffoldKey.currentState!
                  .showBottomSheet((context) => Container(
                        color: ThemeCubit.get(context).isDark
                            ? Colors.black12
                            : Colors.grey[50],
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  onTap: null,
                                  maxLength: 100,
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField(
                                  readOnly: true,
                                  controller: timeController,
                                  isClickable: true,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                        builder: (context, childWidget) {
                                          return MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      alwaysUse24HourFormat:
                                                          true),
                                              child: childWidget!);
                                        }).then((value) {
                                      if (value != null)
                                        timeController.text =
                                            value.toString().substring(10, 15);
                                      time = timeController.text;
                                    });
                                  },
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Time',
                                  prefix: Icons.timer,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField(
                                  readOnly: true,
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  isClickable: true,
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2100-12-31'))
                                        .then((value) {
                                      if (value != null) {
                                        dateController.text =
                                            "${value.day.toString().split("'").last}/${value.month.toString().split("'").last}/${value.year.toString().split("'").last}";
                                        date = value;
                                      }
                                    });
                                  },
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'Date must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Date',
                                  prefix: Icons.calendar_today,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField(
                                  onTap: null,
                                  maxLength: 500,
                                  controller: descriptionController,
                                  type: TextInputType.text,
                                  validate: (String value) {},
                                  label: 'Task Description',
                                  prefix: Icons.description,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .closed
                  .then((value) {
                cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
              });
              cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
            }
          },
          child: Icon(cubit.fabIcon),
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: cubit.currentIndex,
          onTap: (index) {
            cubit.changeIndex(index);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'New Tasks'),
            BottomNavigationBarItem(
                icon: Icon(Icons.check), label: 'Done Tasks'),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive), label: 'Archived Tasks'),
          ],
        ),
      );
    });
  }
}
