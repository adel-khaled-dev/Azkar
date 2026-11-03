import 'package:azkar/core/constants/app_constants.dart';
import 'package:azkar/core/theme/app_theme.dart';
import 'package:azkar/features/adhkar/logic/adhkar_cubit.dart';
import 'package:azkar/features/favorites/logic/favorites_cubit.dart';
import 'package:azkar/features/prayer_times/logic/prayer_cubit.dart';
import 'package:azkar/features/quran/logic/quran_cubit.dart';
import 'package:azkar/features/settings/logic/settings_cubit.dart';
import 'package:azkar/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AzkarApp extends StatelessWidget {
  const AzkarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => AdhkarCubit()),
        BlocProvider(create: (_) => QuranCubit()),
        BlocProvider(create: (_) => FavoritesCubit()),
        BlocProvider(create: (_) => PrayerCubit()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) => MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
          themeAnimationDuration: Duration.zero,
          builder: (context, child) => Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          ),
          home: const SplashPage(),
        ),
      ),
    );
  }
}
