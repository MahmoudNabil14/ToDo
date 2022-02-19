import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        color: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.blue,
          fontFamily: "Urial",
          fontSize: 22.0,
        ),
        iconTheme: IconThemeData(color: Colors.blue),
        actionsIconTheme: IconThemeData(color: Colors.blue)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 50.0,
        selectedIconTheme: IconThemeData(size: 32.0),
        selectedLabelStyle: TextStyle(fontFamily: "Urial", fontSize: 18.0),
        unselectedLabelStyle: TextStyle(
          fontFamily: "Urial",
        )));
ThemeData darkTheme = ThemeData(
    primaryColor: Colors.blue,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black54,
    appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light),
        color: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.blue,
          fontFamily: "Urial",
          fontSize: 22.0,
        ),
        iconTheme: IconThemeData(color: Colors.blue),
        actionsIconTheme: IconThemeData(color: Colors.blue)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.blueGrey[900],
        elevation: 50.0,
        selectedIconTheme: IconThemeData(size: 32.0),
        selectedLabelStyle: TextStyle(fontFamily: "Urial", fontSize: 18.0),
        unselectedLabelStyle: TextStyle(
          fontFamily: "Urial",
        )));
