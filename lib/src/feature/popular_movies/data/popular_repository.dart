import 'dart:convert';

import '../../../common/constant/api_const.dart';
import '../../../common/model/movie_model.dart';
import '../../../common/service/api_service.dart';

abstract interface class IPopularRepository {
  Future<List<MovieModel>> getMovies(int page);
}

class PopularRepository implements IPopularRepository {
  const PopularRepository();

  @override
  Future<List<MovieModel>> getMovies(int page) async {
    final response = await ApiService.request(
      ApiConst.popularPath,
      queryParameters: {
        ...ApiConst.pagination(page),
        ...ApiConst.regionQuery,
        ...ApiConst.apiKeyQuery,
      },
    );

    final json = const JsonDecoder().cast<String, Map<String, Object?>>().convert(response);

    final movies = List<Map<String, Object?>>.from(
      (json['results'] as List),
    ).map(MovieModel.fromJson).toList();

    return movies;
  }
}
