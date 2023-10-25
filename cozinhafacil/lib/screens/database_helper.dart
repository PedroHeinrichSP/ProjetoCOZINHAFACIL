import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user_model.dart';

class DatabaseHelper {
  static final _databaseName = "userDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'users';

  static final columnId = 'id';
  static final columnUsername = 'username';
  static final columnPassword = 'password';

  // torna esta classe singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnUsername TEXT NOT NULL,
            $columnPassword TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(User user) async {
    Database db = await database;
    int id = await db.insert(table, user.toMap());
    return id;
  }

  Future<User?> queryUser(String username) async {
  Database db = await database;
  List<Map> maps = await db.query(table,
      columns: [columnId, columnUsername, columnPassword],
      where: '$columnUsername = ?',
      whereArgs: [username]);
  if (maps.length > 0) {
    return User.fromMap(maps.first.cast<String, dynamic>());
  }
  return null;
}

}
