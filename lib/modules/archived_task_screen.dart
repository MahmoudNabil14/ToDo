import 'package:first_flutter_app/shared/components/components.dart';
import 'package:first_flutter_app/shared/state_manager/app_cubit/app_cubit.dart';
import 'package:first_flutter_app/shared/state_manager/app_cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchivedTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, states) {},
      builder: (context, states) {
        var tasks = AppCubit.get(context).archivedTasks;
        return itemBuilder(tasks: tasks);
      },
    );
  }
}
