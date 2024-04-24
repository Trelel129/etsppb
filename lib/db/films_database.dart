import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/film.dart';

class FilmsDatabase {
  static final FilmsDatabase instance = FilmsDatabase._init();

  static Database? _database;

  FilmsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('films.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const imageType = 'TEXT NULL';
    await db.execute('''
    CREATE TABLE $tableFilms ( 
      ${FilmFields.id} $idType, 
      ${FilmFields.isImportant} $boolType,
      ${FilmFields.number} $integerType,
      ${FilmFields.title} $textType,
      ${FilmFields.description} $textType,
      ${FilmFields.time} $textType,
      ${FilmFields.image} $imageType
      )
    ''');
    // ${FilmFields.image} $imageType
  }

  Future<Film> create(Film film) async {
    final db = await instance.database;

    final id = await db.insert(tableFilms, film.toJson());
    return film.copy(id: id);
  }

  Future<Film> readFilm(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableFilms,
      columns: FilmFields.values,
      where: '${FilmFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Film.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Film>> readAllFilms() async {
    final db = await instance.database;

    final orderBy = '${FilmFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableFilms, orderBy: orderBy);

    return result.map((json) => Film.fromJson(json)).toList();
  }

  Future<int> update(Film film) async {
    final db = await instance.database;

    return db.update(
      tableFilms,
      film.toJson(),
      where: '${FilmFields.id} = ?',
      whereArgs: [film.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableFilms,
      where: '${FilmFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}