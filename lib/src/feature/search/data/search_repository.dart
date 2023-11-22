import 'dart:convert';

import '../../../common/constant/api_const.dart';
import '../../../common/model/movie_model.dart';
import '../../../common/service/api_service.dart';

abstract interface class ISearchRepository {
  Future<List<MovieModel>> getMovies({
    required int page,
    required String text,
  });
}

class SearchRepository implements ISearchRepository {
  @override
  Future<List<MovieModel>> getMovies({
    required int page,
    required String text,
  }) async {
    final response = await ApiService.request(
      ApiConst.searchPath,
      queryParameters: {
        ...ApiConst.searchQuery(page, text),
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
