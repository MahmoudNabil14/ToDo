import 'package:first_flutter_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/home_layout/app_cubit/app_cubit.dart';
import '../../layout/home_layout/app_cubit/app_states.dart';

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
