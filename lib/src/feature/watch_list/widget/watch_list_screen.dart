import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/src/common/localization/app_localizations.dart';

import '../../../common/model/movie_model.dart';
import '../../../common/service/db_service.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../../common/util/custom_extension.dart';
import '../../widget/movie_item.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({super.key});

  @override
  State<WatchListScreen> createState() => WatchListScreenState();
}

class WatchListScreenState extends State<WatchListScreen> {
  final List<MovieModel> movies = [];

  void getMovies() async {
    movies.clear();

    movies.addAll((await DBService().getMovies()).reversed);

    setState(() {});
  }

    @override
    void initState() {
      super.initState();
      getMovies();
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      body: movies.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppIcons.emptyBox),
                    Text(
                      AppLocalizations.of(context).noMovie,
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).searchMovieTitle,
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: AppColors.greyText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              itemCount: movies.length,
              itemBuilder: (context, index) => MovieItem(
                movie: movies[index],
              ),
            ),
    );
  }
}
