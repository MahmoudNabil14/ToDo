import 'package:first_flutter_app/layout/home_layout/cubit/app_cubit.dart';
import 'package:first_flutter_app/layout/home_layout/home_screen.dart';
import 'package:first_flutter_app/shared/bloc_observer.dart';
import 'package:first_flutter_app/shared/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout/notification_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager.initializeNotification();
  Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => AppCubit()..createDatabase())
      ],
      child: MaterialApp(
        theme: lightTheme,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: HomeLayout(),
      ),
    );
  }
}
