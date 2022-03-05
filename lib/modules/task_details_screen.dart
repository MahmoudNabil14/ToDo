import 'package:first_flutter_app/shared/components/components.dart';
import 'package:first_flutter_app/shared/notification_manager.dart';
import 'package:first_flutter_app/shared/state_manager/main_cubit/main_cubit.dart';
import 'package:first_flutter_app/shared/state_manager/main_cubit/main_states.dart';
import 'package:first_flutter_app/shared/state_manager/preferences_cubit/preferences_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Map model;
  late DateTime notificationDateTime;
  var notificationDate;
  var notificationTime;
  bool isInEditMode = false;
  bool saveBtnEnabled = false;

  var titleKey = GlobalKey<FormState>();
  var timeKey = GlobalKey<FormState>();
  var dateKey = GlobalKey<FormState>();

  TextEditingController taskDescriptionController = TextEditingController();
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskTimeController = TextEditingController();
  TextEditingController taskDateController = TextEditingController();

  TaskDetailsScreen({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    taskDescriptionController.text = model['description'];
    taskTitleController.text = model['title'];
    taskTimeController.text = model['time'];
    taskDateController.text = DateFormat.yMMMMd('en_US').format(DateTime.parse(model['date'])).toString();
    notificationDate = model['date'];
    notificationTime = model['time'].toString().split(' ').first;

    return BlocConsumer<MainCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              model['title'],
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              if (model['description'].toString().isEmpty)
                IconButton(
                    tooltip: AppLocalizations.of(context)!.editTaskToolTip,
                    onPressed: isInEditMode == false
                        ? () {
                            isInEditMode = !isInEditMode;
                            MainCubit.get(context).emit(AppEditTaskState());
                          }
                        : () {
                            isInEditMode = !isInEditMode;
                            taskDescriptionController.text =
                                model['description'];
                            taskTitleController.text = model['title'];
                            taskTimeController.text = model['time'];
                            taskDateController.text = DateFormat.yMMMMd('en_US').format(DateTime.parse(model['date'])).toString();
                            saveBtnEnabled = false;
                            MainCubit.get(context).emit(AppEditTaskState());
                          },
                    icon: isInEditMode == false
                        ? Icon(
                            Icons.edit,
                            color: Colors.blue,
                          )
                        : Icon(
                            Icons.close,
                            color: Colors.blue,
                          ))
            ],
          ),
          body: model['description'].toString().isEmpty && isInEditMode == false
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .taskDescriptionHintFallback1
                              .toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontSize: 36.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w900),
                        ),
                        TextSpan(
                            text: AppLocalizations.of(context)!
                                .taskDescriptionHintFallback2,
                            style: Theme.of(context).textTheme.labelMedium)
                      ]),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Form(
                            key: titleKey,
                            child: TextFormField(
                              maxLength: 50,
                              maxLines: null,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Title must not be empty';
                                }
                                return null;
                              },
                              controller: taskTitleController,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                if (value.length == 0 || value.length == 1) {
                                  titleKey.currentState!.validate();
                                }
                                if ((value.length >
                                            model['title'].toString().length ||
                                        value.length <
                                            model['title'].toString().length) &&
                                    value.isNotEmpty) {
                                  saveBtnEnabled = true;
                                }
                                if (value.length ==
                                        model['title'].toString().length - 1 ||
                                    value.length ==
                                        model['title'].toString().length + 1) {
                                  MainCubit.get(context)
                                      .emit(AppEditFormFieldState());
                                }

                                if (value == model['title']) {
                                  saveBtnEnabled = false;
                                  MainCubit.get(context)
                                      .emit(AppEditFormFieldState());
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                label: Text(AppLocalizations.of(context)!
                                    .taskTitleHint),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Form(
                          key: timeKey,
                          child: defaultFormField(
                            context: context,
                            readOnly: true,
                            controller: taskTimeController,
                            isClickable: true,
                            type: TextInputType.datetime,
                            onChange: null,
                            onTap: () {
                              showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, childWidget) {
                                    return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: childWidget!);
                                  }).then((value) {
                                if (value != null) {
                                  var time = DateFormat.Hm().parse(
                                      value.toString().substring(10, 15));
                                  taskTimeController.text =
                                      DateFormat.jm().format(time).toString();
                                  notificationTime =
                                      value.toString().substring(10, 15);
                                  if (taskTimeController.text !=
                                      model['time']) {
                                    saveBtnEnabled = true;
                                    MainCubit.get(context)
                                        .emit(AppEditFormFieldState());
                                  } else {
                                    saveBtnEnabled = false;
                                    MainCubit.get(context)
                                        .emit(AppEditFormFieldState());
                                  }
                                }
                                timeKey.currentState!.validate();
                              });
                            },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Time must not be empty';
                              }
                              return null;
                            },
                            label: AppLocalizations.of(context)!.taskTimeHint,
                            prefix: Icons.timer,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Form(
                          key: dateKey,
                          child: defaultFormField(
                            context: context,
                            readOnly: true,
                            controller: taskDateController,
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
                                  taskDateController.text =
                                      DateFormat.yMMMMd('en_US').format(value);
                                  notificationDate = value.toString().split(' ').first;
                                  if (taskDateController.text !=
                                      DateFormat.yMMMMd('en_US').format(DateTime.parse(model['date'])).toString()) {
                                    saveBtnEnabled = true;
                                    MainCubit.get(context)
                                        .emit(AppEditFormFieldState());
                                  } else {
                                    saveBtnEnabled = false;
                                    MainCubit.get(context)
                                        .emit(AppEditFormFieldState());
                                  }
                                }
                                dateKey.currentState!.validate();
                              });
                            },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Date must not be empty';
                              }
                              return null;
                            },
                            label: AppLocalizations.of(context)!.taskDateHint,
                            prefix: Icons.calendar_today,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          maxLength: 500,
                          maxLines: null,
                          controller: taskDescriptionController,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            if (value.length >
                                    model['description'].toString().length ||
                                value.length <
                                    model['description'].toString().length) {
                              saveBtnEnabled = true;
                            }
                            if (value.length ==
                                    model['description'].toString().length -
                                        1 ||
                                value.length ==
                                    model['description'].toString().length +
                                        1) {
                              MainCubit.get(context)
                                  .emit(AppEditFormFieldState());
                            }
                            if (value == model['description']) {
                              saveBtnEnabled = false;
                              MainCubit.get(context)
                                  .emit(AppEditFormFieldState());
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            label: Text(AppLocalizations.of(context)!
                                .taskDescriptionHint),
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              color: saveBtnEnabled == true
                                  ? Colors.blue
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: MaterialButton(
                            onPressed: saveBtnEnabled == true
                                ? () {
                                    titleKey.currentState!.validate();
                                    timeKey.currentState!.validate();
                                    dateKey.currentState!.validate();
                                    if (titleKey.currentState!.validate() &&
                                        timeKey.currentState!.validate() &&
                                        dateKey.currentState!.validate()) {
                                      MainCubit.get(context).updateTaskData(
                                          title: taskTitleController.text,
                                          time: taskTimeController.text,
                                          date: notificationDate,
                                          description: taskDescriptionController.text,
                                          id: model['id']);
                                      Navigator.pop(context);
                                    }
                                    if (taskDateController.text != DateFormat.yMMMMd('en_US').format(DateTime.parse(model['date'])).toString() ||
                                        taskTimeController.text != model['time']) {
                                      NotificationManager.cancelNotification(
                                          model['id']);
                                      notificationDateTime = DateTime.parse(
                                          "${notificationDate}T$notificationTime");
                                      NotificationManager.scheduledNotification(
                                          id: model['id'],
                                          dateTime: notificationDateTime,
                                          title: taskTitleController.text,
                                          description: taskDescriptionController.text,
                                          context: context);
                                    }

                                  }
                                : null,
                            child: Text(
                              AppLocalizations.of(context)!.editSaveButton,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
