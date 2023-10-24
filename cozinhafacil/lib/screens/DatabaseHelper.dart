import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer';  // Import para usar a função log

class DatabaseHelper {
  static final _databaseName = "myDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'user';

  static final columnId = 'id';
  static final columnUserName = 'username';
  static final columnPassword = 'password';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  Future<Map<String, dynamic>?> fetchUser(String username, String password) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>>? result = await db!.query(table,
        where: '$columnUserName = ? AND $columnPassword = ?',
        whereArgs: [username, password]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }


  // Database reference
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUserName TEXT NOT NULL UNIQUE,
            $columnPassword TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
  Database? db = await instance.database;
  if (db != null) {
    return await db.query(table);
  }
  return [];
}

Future<bool> verifyUser(String username, String password) async {
  Database? db = await instance.database;
  if (db != null) {
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: '$columnUserName = ? AND $columnPassword = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }
  return false;
}

Future<bool> userExists(String username) async {
  Database? db = await instance.database;
  if (db != null) {
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: '$columnUserName = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }
  return false;
}



}
