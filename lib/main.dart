// @dart=2.9
import 'package:bloc/bloc.dart';
import 'package:first_flutter_app/layout/home_layout/home_screen.dart';
import 'package:first_flutter_app/modules/home_screen/HomeScreen.dart';
import 'package:first_flutter_app/modules/bmi_screen/bmi_screen.dart';
import 'package:first_flutter_app/modules/counter_screen/counter_screen.dart';
import 'package:first_flutter_app/modules/login/login_screen.dart';
import 'package:first_flutter_app/modules/users_screen/users_screen.dart';
import 'package:first_flutter_app/shared/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'modules/messenger_screen/messenger_screen.dart';

void main()
{
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
      home: homeLayout(),
    );
  }

}





