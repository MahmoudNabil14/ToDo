import 'package:first_flutter_app/shared/network/local/cache_helper.dart';
import 'package:first_flutter_app/shared/state_manager/main_cubit/main_cubit.dart';
import 'package:first_flutter_app/shared/state_manager/preferences_cubit/preferences_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreferencesCubit extends Cubit<PreferencesStates> {
  PreferencesCubit() : super(ThemeInitialState());

  static PreferencesCubit get(context) => BlocProvider.of(context);

  bool darkModeSwitchIsOn = false;
  static String appLang = 'English';

  void changeAppTheme({bool? fromShared}) {
    if (fromShared != null) {
      darkModeSwitchIsOn = fromShared;
      if (fromShared == true)
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Color(0xff2b2b2b)));
      emit(ChangeThemeState());
    } else {
      darkModeSwitchIsOn = !darkModeSwitchIsOn;
      CacheHelper.saveDate('isDark', darkModeSwitchIsOn);
      if (darkModeSwitchIsOn)
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Color(0xff2b2b2b),
            systemNavigationBarIconBrightness: Brightness.light));
      else {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.grey[100],
            systemNavigationBarIconBrightness: Brightness.dark));
      }
      emit(ChangeThemeState());
    }
  }

  String changeAppLanguage(String lang, context){
    if(lang=='العربية'){
      appLang = 'العربية';
      MainCubit.get(context).soundListValue = 'منبه 1';
      CacheHelper.saveDate('lang', lang);
      emit(ChangeLanguageState());
      return 'ar';
    }else{
      appLang=lang;
      MainCubit.get(context).soundListValue = 'Alarm 1';
      CacheHelper.saveDate('lang', lang);
      emit(ChangeLanguageState());
      return 'en';
    }
  }


}
