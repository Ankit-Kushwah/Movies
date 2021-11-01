// @dart=2.9
import 'dart:io';
import 'package:movie/models/Movies.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'MovieDatabase3.db';
  static const _databaseVersion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    print(dbPath);
    return await openDatabase(dbPath, version: _databaseVersion, onCreate: _onCreateDB);

  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Movie.tblContact}(
        ${Movie.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Movie.colName} TEXT NOT NULL,
        ${Movie.colDirector} TEXT NOT NULL,
        ${Movie.colEmail} TEXT NOT NULL,
        ${Movie.colMovi} TEXT NOT NULL
      )
      ''');
  }
  //AddMovies - Movies insert
  Future<int> insertMovie(Movie movie) async {
    Database db = await database;
    return await db.insert(Movie.tblContact, movie.toMap());
  }
//Movies - update
  Future<int> updateMovie(Movie movie) async {
    Database db = await database;
    return await db.update(Movie.tblContact, movie.toMap(),
        where: '${Movie.colId}=?', whereArgs: [movie.id]);
  }
//Movies - delete
  Future<int> deleteMovie(int id) async {
    Database db = await database;
    return await db.delete(Movie.tblContact,
        where: '${Movie.colId}=?', whereArgs: [id]);
  }
//Movies - retrieve all
  Future<List<Movie>> fetchMovies(Movie movie) async {
    Database db = await database;
    List<Map> movies = await db.query(Movie.tblContact, where: '${Movie.colEmail}=?', whereArgs: [movie.email]);
    return movies.length == 0
    ? []
    : movies.map((x) => Movie.fromMap(x)).toList();
  }


  /*Future<List<Movie>> fetchMovies() async {
    Database db = await database;
    List<Map> movies = await db.query(Movie.tblContact);
    return movies.length == 0
    ? []
    : movies.map((x) => Movie.fromMap(x)).toList();
  }*/
}

