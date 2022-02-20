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
  primaryTextTheme: Typography(platform: TargetPlatform.android).white,
  textTheme: Typography(platform: TargetPlatform.android).white,
  primaryColor: Colors.red,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.black54,
  inputDecorationTheme: InputDecorationTheme(
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[100]!)),
      labelStyle: TextStyle(color: Colors.white),
      prefixIconColor: Colors.white),
  timePickerTheme: TimePickerThemeData(
      dialTextColor: Colors.white,
      hourMinuteTextColor: Colors.white,
      entryModeIconColor: Colors.white,
      backgroundColor: Colors.grey[800]),
  appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light),
      color: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.blue,
        fontFamily: "Urial",
        fontSize: 22.0,
      ),
      iconTheme: IconThemeData(color: Colors.blue),
      actionsIconTheme: IconThemeData(color: Colors.blue)),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[800],
      elevation: 50.0,
      selectedIconTheme: IconThemeData(size: 32.0),
      unselectedIconTheme: IconThemeData(color: Colors.white),
      selectedLabelStyle: TextStyle(
        fontFamily: "Urial",
        fontSize: 18.0,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: "Urial",
      ),
      unselectedItemColor: Colors.white),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.grey[900]),
);
