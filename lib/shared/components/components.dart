import 'package:buildcondition/buildcondition.dart';
import 'package:first_flutter_app/main.dart';
import 'package:first_flutter_app/modules/task_details_screen.dart';
import 'package:first_flutter_app/shared/notification_manager.dart';
import 'package:first_flutter_app/shared/state_manager/main_cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../state_manager/preferences_cubit/preferences_cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color color = Colors.blue,
  required String text,
  bool isUpperCase = true,
  required Function function,
}) =>
    Container(
      color: color,
      width: width,
      child: MaterialButton(
        onPressed: () {
          return function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormField({
  bool readOnly = false,
  required TextEditingController controller,
  required TextInputType type,
  required Function validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  Function? onTap,
  bool obscure = false,
  bool isClickable = true,
  int? maxLength,
}) =>
    TextFormField(
      readOnly: readOnly,
      maxLines: null,
      maxLength: maxLength,
      controller: controller,
      keyboardType: type,

      obscureText: obscure,
      enabled: isClickable,
      onTap: () {
        if (onTap == null) {
          return null;
        } else {
          return onTap();
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefix,
        ),
        labelText: label,
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: () {
                  suffixPressed!();
                })
            : null,
        border: OutlineInputBorder(),
      ),
      validator: (s) {
        return validate(s);
      },
    );

Widget buildTaskItem(Map model, context) => InkWell(
      onTap: () {
        if (MainCubit.get(context).isBottomSheetShown == true)
          Navigator.pop(context);
        // Get.to(TaskDetailsScreen(model: model,));
        MyApp.navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => TaskDetailsScreen(
                  model: model,
                )));
      },
      child: Dismissible(
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          alignment: PreferencesCubit.get(context).appLang=="English"?Alignment.centerRight:Alignment.centerLeft,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 28,
          ),
        ),
        key: Key(model['id'].toString()),
        onDismissed: (direction) {
          NotificationManager.cancelNotification(model['id']);
          MainCubit.get(context).deleteData(id: model['id']);
        },
        confirmDismiss: (DismissDirection direction) async {
          return await showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.deleteDialogBoxTitle.toUpperCase(),
                  style: TextStyle(fontSize: 22.0),
                ),
                content:
                     Text(AppLocalizations.of(context)!.deleteDialogBoxContent),
                actions: [
                  MaterialButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        AppLocalizations.of(context)!.deleteDialogBoxDeleteButton.toUpperCase(),
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      )),
                  MaterialButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      AppLocalizations.of(context)!.deleteDialogBoxCancelButton.toUpperCase(),
                      style: TextStyle(
                          color:
                              PreferencesCubit.get(context).darkModeSwitchIsOn
                                  ? Colors.white
                                  : Colors.black),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40.0,
                child: Text(
                  '${model['time']}',
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${model['title']}',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (model['description'].toString().isNotEmpty)
                      SizedBox(
                        height: 5.0,
                      ),
                    if (model['description'].toString().isNotEmpty)
                      Text(
                        model['description'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.blue,
                        ),
                      ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      '${model['date']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              IconButton(
                  onPressed: () {
                    if (model['status'] == 'new') {
                      MainCubit.get(context)
                          .updateTaskStatus(status: 'done', id: model['id']);
                    } else if (model['status'] == 'archive') {
                      MainCubit.get(context)
                          .updateTaskStatus(status: 'done', id: model['id']);
                    } else {
                      MainCubit.get(context)
                          .updateTaskStatus(status: 'new', id: model['id']);
                    }
                  },
                  icon: model['status'] == 'done'
                      ? Icon(
                          Icons.check_box,
                          color: Colors.grey[800],
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.blue,
                        )),
              IconButton(
                onPressed: () {
                  if (model['status'] == 'new') {
                    MainCubit.get(context)
                        .updateTaskStatus(status: 'archive', id: model['id']);
                  } else if (model['status'] == 'done') {
                    MainCubit.get(context)
                        .updateTaskStatus(status: 'archive', id: model['id']);
                  } else {
                    MainCubit.get(context)
                        .updateTaskStatus(status: 'new', id: model['id']);
                  }
                },
                icon: model['status'] == 'archive'
                    ? Icon(
                        Icons.unarchive,
                        color: Colors.grey[800],
                      )
                    : Icon(
                        Icons.archive,
                        color: Colors.blue,
                      ),
              ),
            ],
          ),
        ),
      ),
    );

Widget itemBuilder({required List<Map> tasks,}) => BuildCondition(
      condition: tasks.length > 0,
      builder: (BuildContext context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(
                height: 1,
                color: Colors.grey[300],
                width: double.infinity,
              ),
          itemCount: tasks.length),
      fallback: (BuildContext context) => Padding(
        padding: const EdgeInsets.only(
            top: 20.0, right: 20.0, left: 20.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Icon(
                  Icons.menu,
                  size: 100.0,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  tasks == MainCubit.get(context).newTasks
                      ? AppLocalizations.of(context)!.newTasksFallback
                      : tasks == MainCubit.get(context).doneTasks
                          ? AppLocalizations.of(context)!.doneTasksFallback
                          : AppLocalizations.of(context)!.archivedTasksFallback,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
