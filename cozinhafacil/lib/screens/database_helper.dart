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

  // Torna esta classe singleton para garantir uma única instância do banco de dados
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Variável para armazenar a instância do banco de dados
  static Database? _database;

  // Método assíncrono para obter a instância do banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!; // Retorna a instância existente se já estiver criada
    _database = await _initDatabase(); // Caso contrário, cria a instância do banco de dados
    return _database!;
  }

  // Inicializa o banco de dados e cria a tabela se não existir
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Método para criar a tabela quando o banco de dados é criado pela primeira vez
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnUsername TEXT NOT NULL,
            $columnPassword TEXT NOT NULL
          )
          ''');
  }

  // Método para inserir um novo usuário no banco de dados
  Future<int> insert(User user) async {
    Database db = await database;
    int id = await db.insert(table, user.toMap());
    return id;
  }

  // Método para consultar um usuário pelo nome de usuário
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
