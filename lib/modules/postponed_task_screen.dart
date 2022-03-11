import 'package:first_flutter_app/shared/components/components.dart';
import 'package:first_flutter_app/shared/state_manager/main_cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/state_manager/main_cubit/main_states.dart';

class PostponedTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, AppStates>(
      listener: (context, states) {},
      builder: (context, states) {
        var tasks = MainCubit.get(context).postponedTasks;
        return itemBuilder(tasks: tasks);
      },
    );
  }
}
