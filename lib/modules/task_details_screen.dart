import 'package:first_flutter_app/layout/home_layout/app_cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../layout/home_layout/app_cubit/app_states.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Map model;
  bool isInEditMode = false;
  bool alarm = false;
  bool saveBtnEnabled = false;

  TextEditingController taskDescriptionController = TextEditingController();

  TaskDetailsScreen({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    taskDescriptionController.text = model['description'];
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              model['title'],
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                  tooltip: 'Edit task',
                  onPressed: isInEditMode == false
                      ? () {
                          isInEditMode = !isInEditMode;
                          AppCubit.get(context).emit(AppEditTaskStatus());
                        }
                      : () {
                          isInEditMode = !isInEditMode;
                          taskDescriptionController.text = model['description'];
                          saveBtnEnabled = false;
                          AppCubit.get(context).emit(AppEditTaskStatus());
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
                          text: "\"this task has no description\"\n"
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
                            text: "Click on edit icon to add description",
                            style: Theme.of(context).textTheme.labelMedium)
                      ]),
                      // "\"this task has no description\"".toUpperCase(),
                      // textAlign: TextAlign.center,
                      // style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      //     fontSize: 36.0,
                      //     color: Colors.red,
                      //     fontWeight: FontWeight.w900),
                    ),
                  ),
                )
              : isInEditMode == false
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: InteractiveViewer(
                          child: SelectableText(
                            "${model['description']}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w700),
                          ),
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
                            TextFormField(
                              maxLength: 500,
                              maxLines: null,
                              controller: taskDescriptionController,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                if (value.length >
                                        model['description']
                                            .toString()
                                            .length ||
                                    value.length <
                                        model['description']
                                            .toString()
                                            .length) {
                                  saveBtnEnabled = true;
                                }
                                if (value.length ==
                                        model['description'].toString().length -
                                            1 ||
                                    value.length ==
                                        model['description'].toString().length +
                                            1) {
                                  AppCubit.get(context)
                                      .emit(AppEditFormFieldStatus());
                                }
                                if (value == model['description']) {
                                  saveBtnEnabled = false;
                                  AppCubit.get(context)
                                      .emit(AppEditFormFieldStatus());
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                label:
                                    Text('Task ${model['title']} Description'),
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
                                        AppCubit.get(context).updateTaskData(
                                            description:
                                                taskDescriptionController.text,
                                            id: model['id']);
                                        Navigator.pop(context);
                                      }
                                    : null,
                                child: Text(
                                  'Save',
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
