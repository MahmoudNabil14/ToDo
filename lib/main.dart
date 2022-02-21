import 'package:first_flutter_app/layout/home_layout/app_cubit/app_cubit.dart';
import 'package:first_flutter_app/layout/home_layout/home_screen.dart';
import 'package:first_flutter_app/layout/home_layout/theme_cubit/theme_cubit.dart';
import 'package:first_flutter_app/layout/home_layout/theme_cubit/theme_states.dart';
import 'package:first_flutter_app/shared/bloc_observer.dart';
import 'package:first_flutter_app/shared/network/local/cache_helper.dart';
import 'package:first_flutter_app/shared/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout/notification_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager.initializeNotification();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData('isDark');

  runApp(MyApp(
    isDark: isDark != null ? isDark : isDark = false,
  ));
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  final bool isDark;

  const MyApp({Key? key, required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => AppCubit()..createDatabase()),
        BlocProvider(
            create: (BuildContext context) =>
                ThemeCubit()..changeAppTheme(fromShared: isDark))
      ],
      child: BlocConsumer<ThemeCubit, ThemeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeCubit.get(context).isDark ? darkTheme : lightTheme,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
