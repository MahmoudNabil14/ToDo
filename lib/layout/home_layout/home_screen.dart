import 'package:buildcondition/buildcondition.dart';
import 'package:first_flutter_app/layout/home_layout/cubit/app_cubit.dart';
import 'package:first_flutter_app/layout/home_layout/cubit/app_states.dart';
import 'package:first_flutter_app/layout/notification_manager.dart';
import 'package:first_flutter_app/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, states) {
            if(states is AppInsertDatabaseState){
              Navigator.pop(context);
              AppCubit.get(context).ChangeIndex(0);
              titleController.text = '';
              dateController.text = '';
              timeController.text = '';
              descriptionController.text = '';

            }
          },
          builder: (context, states) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentIndex]),

              ),
              body: BuildCondition(
                condition: true,
                builder: (BuildContext context) => cubit.screens[cubit.currentIndex],
                fallback: (BuildContext context) => CircularProgressIndicator(),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                        date: dateController.text,
                        title: titleController.text,
                        time: timeController.text,
                        description: descriptionController.text,
                      );
                      NotificationManager.displayNotification(titleController.text);
                    }
                  }
                  else {
                    scaffoldKey.currentState!.showBottomSheet((context) =>
                        Container(
                          color: Colors.grey[100],
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                      controller: titleController,
                                      type: TextInputType.text,
                                      validate: (String value) {
                                        if (value.isEmpty) {
                                          return 'title must not be empty';
                                        }
                                        return null;
                                      },
                                      label: 'Task Title',
                                      prefix: Icons.title,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: timeController,
                                    isClickable: true,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'time must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Time',
                                    prefix: Icons.timer,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    isClickable: true,
                                    onTap: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.parse('2050-12-30')
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'date must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Date',
                                    prefix: Icons.calendar_today,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: descriptionController,
                                    type: TextInputType.text,
                                    validate: (String value) {

                                    },
                                    label: 'Task Description',
                                    prefix: Icons.description,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )).closed.then((value) {
                      cubit.ChangeBottomSheetState(isShow:false, icon:Icons.edit);
                    });
                    cubit.ChangeBottomSheetState(isShow:true, icon:Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon),

              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.ChangeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'NewTask'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline),
                      label: 'DoneTask'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: 'ArchiveTask'),

                ],
              ),
            );
          }),
    );
  }
}
