import 'package:first_flutter_app/layout/main_layout/main_layout.dart';
import 'package:first_flutter_app/shared/bloc_observer.dart';
import 'package:first_flutter_app/shared/network/local/cache_helper.dart';
import 'package:first_flutter_app/shared/state_manager/main_cubit/main_cubit.dart';
import 'package:first_flutter_app/shared/state_manager/preferences_cubit/preferences_cubit.dart';
import 'package:first_flutter_app/shared/state_manager/preferences_cubit/preferences_states.dart';
import 'package:first_flutter_app/shared/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'shared/notification_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager.initializeNotification();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData('isDark');
  String? lang = CacheHelper.getData('lang');

  runApp(MyApp(
    isDark: isDark != null ? isDark : isDark = false,
    lang: lang != null ? lang : lang = 'English',
  ));
  WidgetsBinding.instance!.addObserver(_Handler());
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  final bool isDark;

  final String lang;

  const MyApp({Key? key, required this.isDark, required this.lang})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => MainCubit()..createDatabase()),
        BlocProvider(
            create: (BuildContext context) => PreferencesCubit()
              ..changeAppTheme(fromShared: isDark)
              ..changeAppLanguage(lang, context))
      ],
      child: BlocConsumer<PreferencesCubit, PreferencesStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: PreferencesCubit.get(context).darkModeSwitchIsOn
                ? darkTheme
                : lightTheme,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            locale: PreferencesCubit.appLang == 'العربية'
                ? Locale('ar')
                : Locale('en'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('ar'),
            ],
            home: MainLayout(),
          );
        },
      ),
    );
  }
}

class _Handler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      MainCubit.audioPlayer.stop();
    }
  }
}
