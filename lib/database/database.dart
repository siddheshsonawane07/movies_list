import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String movieTable = "movieTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String imgColumn = "imgColumn";
final String authorColumn = "authorColumn";
final String yearColumn = "yearColumn";
final String statusColumn = "statusColumn";

class DatabaseProvider {

  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "movies.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $movieTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $imgColumn TEXT,"
              "$authorColumn TEXT, $yearColumn TEXT, $statusColumn INTEGER)"
      );
    });
  }
}

