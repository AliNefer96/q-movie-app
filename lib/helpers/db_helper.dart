import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'movies.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies(
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        genreIds TEXT,
        rating REAL,
        releaseDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE favourites(
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        genreIds TEXT,
        rating REAL,
        releaseDate TEXT
      )
    ''');
  }

  Future<void> insertFavourite(Movie movie) async {
    final db = await database;
    await db.insert(
      'favourites',
      {
        'id': movie.id,
        'title': movie.title,
        'overview': movie.overview,
        'posterPath': movie.posterPath,
        'rating': movie.rating,
        'genreIds': jsonEncode(movie.genreIds), 
        'releaseDate': movie.releaseDate,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavourite(int movieId) async {
    final db = await database;
    await db.delete(
      'favourites',
      where: 'id = ?',
      whereArgs: [movieId],
    );
  }

  Future<List<Movie>> getFavourites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favourites');

    return List.generate(maps.length, (i) {
      return Movie(
        id: maps[i]['id'],
        title: maps[i]['title'],
        overview: maps[i]['overview'],
        posterPath: maps[i]['posterPath'],
        releaseDate: maps[i]['releaseDate'],
        rating: maps[i]['rating'],
        genreIds: List<int>.from(jsonDecode(maps[i]['genreIds'])),
      );
    });
  }

  Future<void> insertMovies(List<Movie> movies) async {
    final db = await database;
    Batch batch = db.batch();

    for (var movie in movies) {
      batch.insert(
        'movies',
        {
          'id': movie.id,
          'title': movie.title,
          'overview': movie.overview,
          'posterPath': movie.posterPath,
          'rating': movie.rating,
          'genreIds': jsonEncode(movie.genreIds), 
          'releaseDate': movie.releaseDate,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Movie>> getMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movies');

    return List.generate(maps.length, (i) {
      return Movie(
        id: maps[i]['id'],
        title: maps[i]['title'],
        overview: maps[i]['overview'],
        posterPath: maps[i]['posterPath'],
        releaseDate: maps[i]['releaseDate'],
        rating: maps[i]['rating'],
        genreIds: List<int>.from(jsonDecode(maps[i]['genreIds'])),
      );
    });
  }

  Future<void> clearMovies() async {
    final db = await database;
    await db.delete('movies');
  }
}
