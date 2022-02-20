import 'package:first_flutter_app/layout/theme_cubit/theme_states.dart';
import 'package:first_flutter_app/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(ThemeInitialState());

  static ThemeCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeAppTheme({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      if (fromShared == true)
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(systemNavigationBarColor: Color(0xff2b2b2b)));
      emit(ThemeChangeThemeStatus());
    } else {
      isDark = !isDark;
      CacheHelper.saveDate('isDark', isDark);
      if (isDark)
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Color(0xff2b2b2b),
            systemNavigationBarIconBrightness: Brightness.light));
      else {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.grey[100],
            systemNavigationBarIconBrightness: Brightness.dark));
      }
      emit(ThemeChangeThemeStatus());
    }
  }
}
