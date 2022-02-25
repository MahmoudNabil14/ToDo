import 'package:first_flutter_app/shared/network/local/cache_helper.dart';
import 'package:first_flutter_app/shared/state_manager/preferences_cubit/preferences_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreferencesCubit extends Cubit<PreferencesStates> {
  PreferencesCubit() : super(ThemeInitialState());

  static PreferencesCubit get(context) => BlocProvider.of(context);

  bool darkModeSwitchIsOn = false;
  String appLang = 'English';

  void changeAppTheme({bool? fromShared}) {
    if (fromShared != null) {
      darkModeSwitchIsOn = fromShared;
      if (fromShared == true)
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Color(0xff2b2b2b)));
      emit(ChangeThemeStatus());
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
      emit(ChangeThemeStatus());
    }
  }

  String changeAppLanguage(String lang){
    if(lang=='العربية'){
      appLang = 'العربية';
      CacheHelper.saveDate('lang', lang);
      emit(LanguageChangeState());
      return 'ar';
    }else{
      appLang=lang;
      CacheHelper.saveDate('lang', lang);
      emit(LanguageChangeState());
      return 'en';
    }
  }


}
