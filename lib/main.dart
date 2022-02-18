import 'package:bloc/bloc.dart';
import 'package:first_flutter_app/layout/home_layout/home_screen.dart';
import 'package:first_flutter_app/shared/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'layout/notification_manager.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager.initializeNotification();
  Bloc.observer = MyBlocObserver();

  runApp(MyApp());

}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }

}





