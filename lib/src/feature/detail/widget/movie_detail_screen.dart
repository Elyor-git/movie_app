import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_app/src/common/localization/app_localizations.dart';

import '../../../common/constant/api_const.dart';
import '../../../common/constant/config.dart';
import '../../../common/model/movie_model.dart';
import '../../../common/service/db_service.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/util/custom_extension.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({
    required this.movie,
    super.key,
  });

  final MovieModel movie;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final ValueNotifier<bool> isSelected = ValueNotifier(false);

  void saveToStorage() async {
    final movie = widget.movie.copyWith(isSelected: isSelected.value);
    await DBService().insert(movie.toMap());
  }

  void deleteFromStorage() async {
    await DBService().delete(widget.movie.id);
  }

  void isExist() async {
    isSelected.value = (await DBService().getMovie(widget.movie.id))?.isSelected ?? false;
  }

  void savePressed() {
    isSelected.value = !isSelected.value;

    if (isSelected.value) {
      saveToStorage();
    } else {
      deleteFromStorage();
    }
  }

  @override
  void initState() {
    super.initState();
    isExist();
  }

  @override
  void dispose() {
    isSelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      appBar: AppBar(
        backgroundColor: AppColors.main,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).detail,
          style: context.textTheme.titleLarge?.copyWith(
            color: AppColors.white,
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: isSelected,
            builder: (context, value, child) => IconButton(
              onPressed: savePressed,
              icon: const Icon(
                Icons.bookmark_border,
                size: 28,
              ),
              selectedIcon: const Icon(
                Icons.bookmark,
                size: 28,
              ),
              isSelected: value,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 270,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.movie.backdropPath != null
                                ? ApiConst.imageLoadEntry +
                                    widget.movie.backdropPath!
                                : Config.noImage,
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: const Alignment(.9, .9),
                        child: SizedBox(
                          height: 40,
                          width: 80,
                          child: Card(
                            elevation: 0,
                            color: AppColors.main30,
                            shape: const StadiumBorder(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.star_border_purple500_rounded,
                                  color: AppColors.yellow,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  widget.movie.voteAverage.toStringAsFixed(1),
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: AppColors.yellow,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 190,
                      top: 20,
                      right: 10,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 90,
                        child: Text(
                          widget.movie.title,
                          style: context.textTheme.headlineLarge?.copyWith(
                            color: AppColors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.movie.releaseDate,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.movie.overview,
                        style: context.textTheme.titleLarge?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 170,
                left: 40,
                child: SizedBox(
                  width: 130,
                  height: 200,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.movie.posterPath != null
                              ? ApiConst.imageLoadEntry +
                                  widget.movie.posterPath!
                              : Config.noImage,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
