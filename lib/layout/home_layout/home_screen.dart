import 'package:buildcondition/buildcondition.dart';
import 'package:first_flutter_app/shared/components/components.dart';
import 'package:first_flutter_app/shared/notification_manager.dart';
import 'package:first_flutter_app/shared/state_manager/app_cubit/app_cubit.dart';
import 'package:first_flutter_app/shared/state_manager/app_cubit/app_states.dart';
import 'package:first_flutter_app/shared/state_manager/theme_cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var descriptionController = TextEditingController();
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
                notificationDateTime = DateTime.parse(
                    "${dateController.text}T${timeController.text}");
                NotificationManager.displayNotification(titleController.text);
                NotificationManager.scheduledNotification(notificationDateTime,
                    titleController.text, descriptionController.text);
              }
            } else {
              titleController.text = '';
              timeController.text = '';
              dateController.text = '';
              descriptionController.text = '';
              AppCubit.get(context).switchIsOn=false;
              scaffoldKey.currentState!
                  .showBottomSheet((context) => BottomSheetWidget(
                        dateController: dateController,
                        descriptionController: descriptionController,
                        formKey: formKey,
                        timeController: timeController,
                        titleController: titleController,
                      ))
                  .closed
                  .then((value) {
                cubit.changeBottomSheetState(isShow: false);
              });
              cubit.changeBottomSheetState(isShow: true);
            }
          },
          child: Icon(Icons.add),
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

class BottomSheetWidget extends StatelessWidget {
  final formKey;
  final titleController;
  final dateController;
  final timeController;
  final descriptionController;

  BottomSheetWidget(
      {Key? key,
      this.formKey,
      this.titleController,
      this.dateController,
      this.timeController,
      this.descriptionController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            color: ThemeCubit.get(context).isDark
                ? Colors.grey[900]
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
                                      .copyWith(alwaysUse24HourFormat: true),
                                  child: childWidget!);
                            }).then((value) {
                          if (value != null)
                            timeController.text =
                                value.toString().substring(10, 15);
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
                                builder: (context, Widget? child) {
                                  if (ThemeCubit.get(context).isDark) {
                                    return Theme(
                                      data: ThemeData.dark().copyWith(
                                        colorScheme: ColorScheme.dark(
                                          primary: Colors.blue,
                                          onPrimary: Colors.white,
                                          surface: Colors.blue,
                                          onSurface: Colors.white,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  } else {
                                    return Theme(
                                      data: ThemeData.light(),
                                      child: child!,
                                    );
                                  }
                                },
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2100-12-31'))
                            .then((value) {
                          if (value != null) {
                            print(value);
                            dateController.text =
                                value.toString().split(' ').first;
                            // "${value.year.toString().split("'").last}-${value.month.toString().split("'").last}-${value.day.toString().split("'").last}";
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
                    Row(
                      children: [
                        Text(
                          'Alarm sound',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                        Switch(
                            value: AppCubit.get(context).switchIsOn,
                            onChanged: (newValue) {
                              AppCubit.get(context)
                                  .changeSwitchButton(isOn: newValue);
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
