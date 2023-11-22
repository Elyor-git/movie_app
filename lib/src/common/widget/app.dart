import 'package:flutter/material.dart';

import '../../feature/popular_movies/widget/home_screen.dart';
import '../localization/app_localizations.dart';
import '../service/db_service.dart';
import '../style/app_colors.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  ValueNotifier<Locale> locale = ValueNotifier(Locale($storage.getString(StorageKeys.language.key) ?? 'uz'));

  void changeLocale(Locale newLocale) => locale.value = newLocale;

  @override
  void dispose() {
    locale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: locale,
      builder: (context, value, child) {
        return MaterialApp(
          title: 'MovieApp',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: value,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: AppColors.main,
            fontFamily: 'Poppins',
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(
                color: AppColors.white,
              ),
            ),
            navigationBarTheme: const NavigationBarThemeData(
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              elevation: 2,
              backgroundColor: AppColors.main,
              indicatorColor: AppColors.main,
              indicatorShape: CircleBorder(),
              labelTextStyle: MaterialStatePropertyAll(
                TextStyle(
                  color: AppColors.blue,
                ),
              ),
            ),
          ),
          home: child,
        );
      },
      child: const HomeScreen(),
    );
  }
}
