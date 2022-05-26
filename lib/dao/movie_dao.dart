import 'dart:async';
import 'package:fluttermovie/models/movie.dart';
import 'package:fluttermovie/database/database.dart';
import 'package:sqflite/sqflite.dart';

class MovieDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<Movie> saveMovie(Movie movie) async {
    final db = await dbProvider.db;
    movie.id = await db.insert(movieTable, movie.toMap());
    return movie;
  }

  Future<Movie> getMovie(int id) async {
    final db = await dbProvider.db;
    List<Map> maps = await db.query(movieTable,
        columns: [idColumn, nameColumn, imgColumn, authorColumn, yearColumn, statusColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Movie.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteMovie(int id) async {
    final db = await dbProvider.db;
    return await db
        .delete(movieTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateMovie(Movie movie) async {
    final db = await dbProvider.db;
    return await db.update(movieTable, movie.toMap(),
        where: "$idColumn = ?", whereArgs: [movie.id]);
  }

  Future<List> getMovies() async {
    final db = await dbProvider.db;
    List listMap = await db.rawQuery("SELECT * FROM $movieTable");
    List<Movie> listMovies = [];
    for (Map m in listMap) {
      listMovies.add(Movie.fromMap(m));
    }
    return listMovies;
  }

  Future<int> getNumber() async {
    final db = await dbProvider.db;
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $movieTable"));
  }

  Future close() async {
    final db = await dbProvider.db;
    db.close();
  }
}
