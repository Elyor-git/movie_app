import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/src/common/widget/app.dart';

import '../../../common/localization/app_localizations.dart';
import '../../../common/service/db_service.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../../common/util/custom_extension.dart';
import '../../search/widget/search_screen.dart';
import '../../watch_list/widget/watch_list_screen.dart';
import 'popular_movie_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final PageController controller;
  int pageNumber = 0;
  ValueNotifier<String> language = ValueNotifier("en");

  late final FocusNode focus;

  void pageChange(int index) {
    pageNumber = index;

    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller = PageController();
    focus = FocusNode(debugLabel: 'search_text_field_focus');
  }

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  void changeLanguage(String selectedLanguage) async {
    language.value = selectedLanguage;
    context
        .findAncestorStateOfType<AppState>()
        ?.changeLocale(Locale(selectedLanguage));
    await $storage.setString(StorageKeys.language.key, selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          switch (pageNumber) {
            0 => AppLocalizations.of(context).whatToWatch,
            1 => AppLocalizations.of(context).search,
            2 => AppLocalizations.of(context).watchList,
            _ => '',
          },
          style: context.textTheme.titleMedium?.copyWith(
            color: AppColors.white,
          ),
        ),
        actions: [
          RotatedBox(
            quarterTurns: 1,
            child: ValueListenableBuilder(
              valueListenable: language,
              builder: (context, value, child) {
                return PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) {
                    return const <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'en',
                        child: Text('Eng'),
                      ),
                      PopupMenuItem<String>(
                        value: 'uz',
                        child: Text('Uzb'),
                      ),
                    ];
                  },
                  onSelected: changeLanguage,
                );
              },
            ),
          ),
        ],
      ),
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          PopularMovieScreen(),
          SearchScreen(),
          WatchListScreen(),
        ],
      ),
      bottomNavigationBar: ColoredBox(
        color: AppColors.blue,
        child: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: NavigationBar(
            onDestinationSelected: pageChange,
            selectedIndex: pageNumber,
            destinations: [
              NavigationDestination(
                icon: SvgPicture.asset(AppIcons.home),
                selectedIcon: SvgPicture.asset(
                  AppIcons.home,
                  colorFilter: const ColorFilter.mode(
                    AppColors.blue,
                    BlendMode.srcATop,
                  ),
                ),
                label: AppLocalizations.of(context).home,
              ),
              NavigationDestination(
                icon: SvgPicture.asset(AppIcons.search),
                selectedIcon: SvgPicture.asset(
                  AppIcons.search,
                  colorFilter: const ColorFilter.mode(
                    AppColors.blue,
                    BlendMode.srcATop,
                  ),
                ),
                label: AppLocalizations.of(context).search,
              ),
              NavigationDestination(
                icon: SvgPicture.asset(AppIcons.save),
                selectedIcon: SvgPicture.asset(
                  AppIcons.save,
                  colorFilter: const ColorFilter.mode(
                    AppColors.blue,
                    BlendMode.srcATop,
                  ),
                ),
                label: AppLocalizations.of(context).save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
