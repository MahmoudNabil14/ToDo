import 'package:buildcondition/buildcondition.dart';
import 'package:first_flutter_app/shared/components/components.dart';
import 'package:first_flutter_app/shared/state_manager/app_cubit/app_cubit.dart';
import 'package:first_flutter_app/shared/state_manager/app_cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../shared/state_manager/preferences_cubit/preferences_cubit.dart';

class MainLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(listener: (context, states) {
      if (states is AppInsertDatabaseState) {
        Navigator.pop(context);
        cubit.changeIndex(0);
        cubit.titleController.text = '';
        cubit.dateController.text = '';
        cubit.timeController.text = '';
        cubit.descriptionController.text = '';
      }
    }, builder: (context, states) {
      AppCubit cubit = AppCubit.get(context);
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.menu,size: 32.0,), onPressed: () {
            if(AppCubit.get(context).isBottomSheetShown)
              Navigator.pop(context);
            scaffoldKey.currentState!.openDrawer(); },),
          title: Text(cubit.titles[cubit.currentIndex]),
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
              if (cubit.formKey.currentState!.validate()) {
                cubit.insertToDatabase(
                  date: cubit.dateController.text,
                  title: cubit.titleController.text,
                  time: cubit.timeController.text,
                  description: cubit.descriptionController.text,
                  context: context,
                );
              }
            } else {
              cubit.titleController.text = '';
              cubit.timeController.text = '';
              cubit.dateController.text = '';
              cubit.descriptionController.text = '';
              cubit.soundSwitchIsOn = false;
              cubit.soundListValue = 'basic_alarm.mp3';
              scaffoldKey.currentState!
                  .showBottomSheet((context) => BottomSheetWidget(
                        formKey: cubit.formKey,
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
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: AppLocalizations.of(context)!.newTasks),
            BottomNavigationBarItem(
                icon: Icon(Icons.check), label: AppLocalizations.of(context)!.doneTasks),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive), label: AppLocalizations.of(context)!.archivedTasks),
          ],
        ),
        drawer: InkWell(
          onTap: (){
            if(AppCubit.get(context).isBottomSheetShown){
              Navigator.pop(context);
            }
          },
          child: Drawer(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  DrawerHeader(
                    child: Container(
                      child: Center(
                        child: Text(
                          'Tox'.toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'Urial',
                              fontSize: 60.0,
                              color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text('Dark mode:',style: TextStyle(fontSize: 16.0),),
                      Switch(
                          value: PreferencesCubit.get(context).darkModeSwitchIsOn,
                          onChanged: (newValue) {
                            PreferencesCubit.get(context).changeAppTheme();
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text('Language:',style: TextStyle(fontSize: 16.0),),
                      SizedBox(
                        width: 20.0,
                      ),
                      DropdownButton(
                          value: PreferencesCubit.get(context).appLang,
                          items: [
                            'English',
                            'العربية',
                          ].map((e) {
                            return DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            );
                          }).toList(),
                          onChanged: (value) {
                            PreferencesCubit.get(context).changeAppLanguage(value.toString());
                          }),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class BottomSheetWidget extends StatelessWidget {
  final formKey;

  BottomSheetWidget({
    Key? key,
    this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            color: PreferencesCubit.get(context).darkModeSwitchIsOn
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
                      controller: cubit.titleController,
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
                      controller: cubit.timeController,
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
                            cubit.timeController.text =
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
                      controller: cubit.dateController,
                      type: TextInputType.datetime,
                      isClickable: true,
                      onTap: () {
                        showDatePicker(
                                context: context,
                                builder: (context, Widget? child) {
                                  if (PreferencesCubit.get(context)
                                      .darkModeSwitchIsOn) {
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
                            cubit.dateController.text =
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
                      controller: cubit.descriptionController,
                      type: TextInputType.text,
                      validate: (String value) {},
                      label: 'Task Description',
                      prefix: Icons.description,
                    ),
                    Row(
                      children: [
                        Text(
                          'Alarm sound:',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        DropdownButton(
                            value: cubit.soundListValue,
                            items: [
                              'basic_alarm.mp3',
                              'bell_alarm.mp3',
                              'creepy_clock.mp3',
                              'twin_bell_alarm.mp3',
                              'alarm_slow.mp3'
                            ].map((e) {
                              return DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (value) {
                              AppCubit.get(context).changeSoundListValue(
                                  value: value.toString());
                            }),
                        Switch(
                            value: cubit.soundSwitchIsOn,
                            inactiveTrackColor: PreferencesCubit.get(context).darkModeSwitchIsOn?Colors.grey:Colors.grey,
                            onChanged: (newValue) {
                              AppCubit.get(context)
                                  .changeSoundSwitchButton(isOn: newValue);
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
