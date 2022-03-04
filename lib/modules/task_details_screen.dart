import 'package:first_flutter_app/shared/state_manager/main_cubit/main_cubit.dart';
import 'package:first_flutter_app/shared/state_manager/main_cubit/main_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Map model;
  bool isInEditMode = false;
  bool saveBtnEnabled = false;

  TextEditingController taskDescriptionController = TextEditingController();

  TaskDetailsScreen({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    taskDescriptionController.text = model['description'];
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
              IconButton(
                  tooltip: AppLocalizations.of(context)!.editTaskToolTip,
                  onPressed: isInEditMode == false
                      ? () {
                          isInEditMode = !isInEditMode;
                          MainCubit.get(context).emit(AppEditTaskState());
                        }
                      : () {
                          isInEditMode = !isInEditMode;
                          taskDescriptionController.text = model['description'];
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
                                    MainCubit.get(context).updateTaskData(
                                        description:
                                            taskDescriptionController.text,
                                        id: model['id']);
                                    Navigator.pop(context);
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
