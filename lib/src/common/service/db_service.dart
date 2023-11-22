import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../model/movie_model.dart';

enum StorageKeys {
  language('language'),
  movies('movies');

  const StorageKeys(this.key);

  final String key;
}

late final SharedPreferences $storage;

late final Database $database;

class DBService {
  static Future<void> initialize() async {
    $storage = await SharedPreferences.getInstance();

    $database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) => db.execute(
        'CREATE TABLE ${StorageKeys.movies.key}('
            'id INTEGER,'
            'adult INTEGER,'
            'backdropPath TEXT,'
            'genreIds TEXT,'
            'originalLanguage TEXT,'
            'originalTitle TEXT,'
            'overview TEXT,'
            'popularity REAL,'
            'posterPath TEXT,'
            'releaseDate TEXT,'
            'title TEXT,'
            'video INTEGER,'
            'voteAverage REAL,'
            'voteCount INTEGER,'
            'isSelected INTEGER'
            ')',
      ),
      version: 1,
    );
  }

  Future<void> insert(Map<String, Object?> movie) => $database.insert(StorageKeys.movies.key, movie);

  Future<List<MovieModel>> getMovies() async => (await $database.query(
    StorageKeys.movies.key,
  ))
      .map(MovieModel.fromMap)
      .toList();

  Future<void> delete(int id) => $database.delete(
    StorageKeys.movies.key,
    where: 'id = ?',
    whereArgs: [id],
  );

  Future<MovieModel?> getMovie(int id) async => (await $database.query(
    StorageKeys.movies.key,
    where: 'id = ? ',
    whereArgs: [id],
  ))
      .map(MovieModel.fromMap)
      .firstOrNull;
}
