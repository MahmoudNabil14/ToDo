import 'package:buildcondition/buildcondition.dart';
import 'package:first_flutter_app/shared/components/components.dart';
import 'package:first_flutter_app/shared/state_manager/main_cubit/main_cubit.dart';
import 'package:first_flutter_app/shared/state_manager/main_cubit/main_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../shared/constants.dart';
import '../../shared/state_manager/preferences_cubit/preferences_cubit.dart';

class MainLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    MainCubit cubit = MainCubit.get(context);
    return BlocConsumer<MainCubit, AppStates>(listener: (context, states) {
      if (states is AppInsertDatabaseState) {
        Navigator.pop(context);
        cubit.changeIndex(0);
        cubit.titleController.text = '';
        cubit.dateController.text = '';
        cubit.timeController.text = '';
        cubit.descriptionController.text = '';
      }
    }, builder: (context, states) {
      MainCubit cubit = MainCubit.get(context);
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              size: 32.0,
            ),
            onPressed: () {
              MainCubit.audioPlayer.stop();
              if (MainCubit.get(context).isBottomSheetShown)
                Navigator.pop(context);
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: Text(cubit.currentIndex == 0
              ? AppLocalizations.of(context)!.newTasks
              : cubit.currentIndex == 1
                  ? AppLocalizations.of(context)!.doneTasks
                  : AppLocalizations.of(context)!.archivedTasks),
          actions: [
            IconButton(
                onPressed: () async {
                  if((MainCubit.get(context).currentIndex == 0 && MainCubit.get(context).newTasks.isEmpty)||(MainCubit.get(context).currentIndex == 1 && MainCubit.get(context).doneTasks.isEmpty)||(MainCubit.get(context).currentIndex == 2 && MainCubit.get(context).archivedTasks.isEmpty)){
                    Fluttertoast.showToast(
                      msg:  MainCubit.get(context).currentIndex == 0
                          ? AppLocalizations.of(context)!
                          .deleteNewTasksToastFallback
                          : MainCubit.get(context)
                          .currentIndex ==
                          1
                          ? AppLocalizations.of(context)!
                          .deleteDoneTasksToastFallback
                          : AppLocalizations.of(context)!
                          .deleteArchivedTasksToastFallback,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }else{
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            AppLocalizations.of(context)!
                                .deleteDialogBoxTitle
                                .toUpperCase(),
                            style: TextStyle(fontSize: 22.0),
                          ),
                          content: Text(MainCubit.get(context).currentIndex == 0
                              ? AppLocalizations.of(context)!
                              .deleteNewTasksDialogBoxContent
                              : MainCubit.get(context).currentIndex == 1
                              ? AppLocalizations.of(context)!
                              .deleteDoneTasksDialogBoxContent
                              : AppLocalizations.of(context)!
                              .deleteArchivedTasksDialogBoxContent),
                          actions: [
                            MaterialButton(
                                onPressed: () {
                                  MainCubit.get(context).deleteTasks(
                                      deletedTasks: DeletedTasks.SECTION,
                                      status:
                                      MainCubit.get(context).currentIndex == 0
                                          ? "new"
                                          : MainCubit.get(context)
                                          .currentIndex ==
                                          1
                                          ? "done"
                                          : "archived");
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: MainCubit.get(context).currentIndex == 0
                                          ? AppLocalizations.of(context)!
                                          .deleteNewTasksToast
                                          : MainCubit.get(context)
                                          .currentIndex ==
                                          1
                                          ? AppLocalizations.of(context)!
                                          .deleteDoneTasksToast
                                          : AppLocalizations.of(context)!
                                          .deleteArchivedTasksToast,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                      PreferencesCubit.get(context)
                                          .darkModeSwitchIsOn
                                          ? Colors.grey[700]
                                          : Colors.grey[200],
                                      textColor: Colors.red,
                                      fontSize: 16.0);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .deleteDialogBoxTitle
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16.0),
                                )),
                            MaterialButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .deleteDialogBoxCancelButton
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: PreferencesCubit.get(context)
                                        .darkModeSwitchIsOn
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                icon: Icon(
                  Icons.delete_outline,
                  size: 28,
                ))
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
          tooltip: AppLocalizations.of(context)!.addTaskToolTip,
          onPressed: () {
            if (cubit.isBottomSheetShown) {
              cubit.titleKey.currentState!.validate();
              cubit.timeKey.currentState!.validate();
              cubit.dateKey.currentState!.validate();
              if (cubit.titleKey.currentState!.validate() &&
                  cubit.timeKey.currentState!.validate() &&
                  cubit.dateKey.currentState!.validate()) {
                MainCubit.audioPlayer.stop();
                cubit.insertToDatabase(
                  date: cubit.notificationDate,
                  title: cubit.titleController.text,
                  time: cubit.notificationTime,
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
              MainCubit.get(context).soundListValue =
                  AppLocalizations.of(context)!.alarmSoundValue;
              scaffoldKey.currentState!
                  .showBottomSheet((context) => BottomSheetWidget())
                  .closed
                  .then((value) {
                MainCubit.audioPlayer.stop();
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
            BottomNavigationBarItem(
                tooltip: '',
                icon: Icon(Icons.menu),
                label: AppLocalizations.of(context)!.newTasks),
            BottomNavigationBarItem(
                tooltip: '',
                icon: Icon(Icons.check),
                label: AppLocalizations.of(context)!.doneTasks),
            BottomNavigationBarItem(
                tooltip: '',
                icon: Icon(Icons.archive),
                label: AppLocalizations.of(context)!.archivedTasks),
          ],
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawerHeader(
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
                  Text(
                    AppLocalizations.of(context)!.drawerSettings,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22.0,
                        color: Colors.blue),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                    width: double.infinity,
                  ),
                  Row(
                    children: [
                      Icon(Icons.brightness_2),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.darkMode,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                          value:
                              PreferencesCubit.get(context).darkModeSwitchIsOn,
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
                      Icon(Icons.language),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.language,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      DropdownButton(
                          value: PreferencesCubit.appLang,
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
                            PreferencesCubit.get(context)
                                .changeAppLanguage(value.toString(), context);
                            print(PreferencesCubit.appLang);
                            print(MainCubit.get(context).soundListValue);
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    AppLocalizations.of(context)!.drawerSupportTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22.0,
                        color: Colors.blue),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  InkWell(
                    onTap: () {},
                    child: SizedBox(
                      height: 40.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline_rounded),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            AppLocalizations.of(context)!.drawerHelp,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  InkWell(
                    onTap: () {},
                    child: SizedBox(
                      height: 40.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.share),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .drawerShareWithFriends,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  InkWell(
                    onTap: () {},
                    child: SizedBox(
                      height: 40.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rate_outlined),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            AppLocalizations.of(context)!.drawerRate,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                    width: double.infinity,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () async {
                        if (MainCubit.get(context).newTasks.isNotEmpty ||
                            MainCubit.get(context).doneTasks.isNotEmpty ||
                            MainCubit.get(context).archivedTasks.isNotEmpty) {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .deleteDialogBoxTitle
                                      .toUpperCase(),
                                  style: TextStyle(fontSize: 22.0),
                                ),
                                content: Text(AppLocalizations.of(context)!
                                    .deleteAllTasksDialogBoxContent),
                                actions: [
                                  MaterialButton(
                                      onPressed: () {
                                        MainCubit.get(context).deleteTasks(
                                            deletedTasks: DeletedTasks.ALL);
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(
                                            msg: AppLocalizations.of(context)!
                                                .deleteTasksToast,
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                PreferencesCubit.get(context)
                                                        .darkModeSwitchIsOn
                                                    ? Colors.grey[700]
                                                    : Colors.grey[200],
                                            textColor: Colors.red,
                                            fontSize: 16.0);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .deleteDialogBoxTitle
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 16.0),
                                      )),
                                  MaterialButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .deleteDialogBoxCancelButton
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: PreferencesCubit.get(context)
                                                  .darkModeSwitchIsOn
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)!
                                .deleteTasksToastFallback,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.drawerDeleteAllTasks,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
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
  @override
  Widget build(BuildContext context) {
    MainCubit.get(context).player.fixedPlayer = MainCubit.audioPlayer;
    MainCubit cubit = MainCubit.get(context);
    return BlocConsumer<MainCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            color: PreferencesCubit.get(context).darkModeSwitchIsOn
                ? Colors.grey[900]
                : Colors.grey[50],
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Form(
                      key: cubit.titleKey,
                      child: defaultFormField(
                        maxLength: 50,
                        context: context,
                        onChange: (value) {
                          if (value.length == 0 || value.length == 1)
                            cubit.titleKey.currentState!.validate();
                        },
                        onTap: null,
                        controller: cubit.titleController,
                        type: TextInputType.text,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context)!.taskTitleValidateMsg;
                          }
                          return null;
                        },
                        label: AppLocalizations.of(context)!.taskTitleHint,
                        prefix: Icons.title,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Form(
                    key: cubit.timeKey,
                    child: defaultFormField(
                      context: context,
                      readOnly: true,
                      controller: cubit.timeController,
                      isClickable: true,
                      type: TextInputType.datetime,
                      onChange: null,
                      onTap: () {
                        showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, childWidget) {
                              return MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: false),
                                  child: childWidget!);
                            }).then((value) {
                          if (value != null) {
                            var time = DateFormat.Hm()
                                .parse(value.toString().substring(10, 15));
                            cubit.timeController.text =
                                DateFormat.jm().format(time).toString();
                            cubit.notificationTime =
                                value.toString().substring(10, 15);
                          }
                          cubit.timeKey.currentState!.validate();
                        });
                      },
                      validate: (String value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context)!.taskTimeValidateMsg;
                        }
                        return null;
                      },
                      label: AppLocalizations.of(context)!.taskTimeHint,
                      prefix: Icons.timer,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Form(
                    key: cubit.dateKey,
                    child: defaultFormField(
                      context: context,
                      readOnly: true,
                      controller: cubit.dateController,
                      type: TextInputType.datetime,
                      isClickable: true,
                      onChange: null,
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
                            .then((value) async {
                          if (value != null) {
                            cubit.dateController.text =
                                DateFormat.yMMMMd('en_US').format(value);
                            cubit.notificationDate =
                                value.toString().split(' ').first;
                          }
                          cubit.dateKey.currentState!.validate();
                        });
                      },
                      validate: (String value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context)!.taskDateValidateMsg;
                        }
                        return null;
                      },
                      label: AppLocalizations.of(context)!.taskDateHint,
                      prefix: Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  defaultFormField(
                    context: context,
                    onTap: null,
                    maxLength: 500,
                    controller: cubit.descriptionController,
                    type: TextInputType.text,
                    onChange: null,
                    validate: (String value) {},
                    label: AppLocalizations.of(context)!.taskDescriptionHint,
                    prefix: Icons.description,
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.alarmSound,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Switch(
                          value: cubit.soundSwitchIsOn,
                          inactiveTrackColor:
                              PreferencesCubit.get(context).darkModeSwitchIsOn
                                  ? Colors.grey
                                  : Colors.grey,
                          onChanged: (newValue) {
                            MainCubit.get(context)
                                .changeSoundSwitchButton(isOn: newValue);
                          }),
                      const SizedBox(
                        width: 20.0,
                      ),
                      if (MainCubit.get(context).soundSwitchIsOn)
                        Expanded(
                          child: DropdownButton(
                              isExpanded: true,
                              onTap: () {
                                MainCubit.audioPlayer.stop();
                              },
                              value: MainCubit.get(context).soundListValue,
                              items: [
                                AppLocalizations.of(context)!.alarmSound1,
                                AppLocalizations.of(context)!.alarmSound2,
                                AppLocalizations.of(context)!.alarmSound3,
                                AppLocalizations.of(context)!.alarmSound4,
                                AppLocalizations.of(context)!.alarmSound5,
                                AppLocalizations.of(context)!.alarmSound6,
                                AppLocalizations.of(context)!.alarmSound7,
                                AppLocalizations.of(context)!.alarmSound8,
                                AppLocalizations.of(context)!.alarmSound9,
                                AppLocalizations.of(context)!.alarmSound10,
                              ].map((e) {
                                return DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (value) async {
                                MainCubit.audioPlayer.stop();
                                MainCubit.get(context).changeSoundListValue(
                                    value: value.toString());
                                String alarmAudioPath = MainCubit.get(context)
                                                .soundListValue ==
                                            'Alarm 1' ||
                                        MainCubit.get(context).soundListValue ==
                                            'منبه 1'
                                    ? "sounds/alarm_1.mp3"
                                    : MainCubit.get(context).soundListValue == 'Alarm 2' ||
                                            MainCubit.get(context).soundListValue ==
                                                'منبه 2'
                                        ? 'sounds/alarm_2.mp3'
                                        : MainCubit.get(context).soundListValue == 'Alarm 3' ||
                                                MainCubit.get(context).soundListValue ==
                                                    'منبه 3'
                                            ? 'sounds/alarm_3.mp3'
                                            : MainCubit.get(context).soundListValue == 'Alarm 4' ||
                                                    MainCubit.get(context).soundListValue ==
                                                        'منبه 4'
                                                ? 'sounds/alarm_4.mp3'
                                                : MainCubit.get(context).soundListValue == 'Alarm 5' ||
                                                        MainCubit.get(context)
                                                                .soundListValue ==
                                                            'منبه 5'
                                                    ? 'sounds/alarm_5.mp3'
                                                    : MainCubit.get(context).soundListValue == 'Alarm 6' ||
                                                            MainCubit.get(context).soundListValue == 'منبه 5'
                                                        ? 'sounds/alarm_6.mp3'
                                                        : MainCubit.get(context).soundListValue == 'Alarm 7' || MainCubit.get(context).soundListValue == 'منبه 7'
                                                            ? 'sounds/alarm_7.mp3'
                                                            : MainCubit.get(context).soundListValue == 'Alarm 8' || MainCubit.get(context).soundListValue == 'منبه 6'
                                                                ? 'sounds/alarm_8.mp3'
                                                                : MainCubit.get(context).soundListValue == 'Alarm 9' || MainCubit.get(context).soundListValue == 'منبه 9'
                                                                    ? 'sounds/alarm_9.mp3'
                                                                    : 'sounds/alarm_10.mp3';
                                MainCubit.get(context)
                                    .player
                                    .play(alarmAudioPath);
                                await Future.delayed(Duration(seconds: 5));
                                MainCubit.audioPlayer.stop();
                              }),
                        ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

// showDialog(context: context, builder: (context){
// return SimpleDialog(
// titleTextStyle: TextStyle(
// fontFamily: "Urial",
// color: Colors.blue,
// fontSize: 30.0
// ),
// title: Text("Tox",textAlign: TextAlign.center),
// children: [
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 5.0),
// child: Text(AppLocalizations.of(context)!.layoutHelpDialogBody,style: TextStyle(
// fontSize: 15.0,
// fontWeight: FontWeight.w600
// ),
// ),
// )
// ],
// );
// });
