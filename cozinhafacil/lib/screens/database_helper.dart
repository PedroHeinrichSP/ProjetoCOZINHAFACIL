import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user_model.dart';

// Classe para ajudar a interagir com o banco de dados SQLite
class DatabaseHelper {
  static final _databaseName = "userDatabase.db"; // Nome do banco de dados
  static final _databaseVersion = 1; // Versão do banco de dados

  static final table = 'users'; // Nome da tabela no banco de dados
  static final columnId = 'id'; // Nome da coluna de ID na tabela
  static final columnUsername = 'username'; // Nome da coluna de nome de usuário na tabela
  static final columnPassword = 'password'; // Nome da coluna de senha na tabela

  // Construtor privado para implementar o padrão Singleton
  DatabaseHelper._privateConstructor();
  // Instância estática de DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database; // Referência para o banco de dados

  // Método para obter o banco de dados
  Future<Database> get database async {
    // Retorna o banco de dados, se já estiver inicializado
    if (_database != null) return _database!;
    // Inicializa o banco de dados se ainda não estiver inicializado
    _database = await _initDatabase();
    return _database!;
  }

  // Método para inicializar o banco de dados
  Future _initDatabase() async {
    // Caminho onde o banco de dados será armazenado
    String path = join(await getDatabasesPath(), _databaseName);
    // Abre ou cria o banco de dados SQLite no caminho especificado
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // Método para criar a tabela no banco de dados
  Future _onCreate(Database db, int version) async {
    // Executa a query SQL para criar a tabela com as colunas especificadas
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnUsername TEXT NOT NULL,
            $columnPassword TEXT NOT NULL
          )
          ''');
  }

  // Método para inserir um usuário no banco de dados
  Future<int> insert(User user) async {
    // Verifica se o usuário já existe no banco de dados
    if (await checkIfUserExists(user.username!)) {
      return -1; // Retorna -1 se o usuário já existir
    }
    // Obtém o banco de dados
    Database db = await database;
    // Insere o usuário na tabela e retorna o ID
    int id = await db.insert(table, user.toMap());
    return id;
  }

  // Método para consultar um usuário com base no nome de usuário
  Future<User?> queryUser(String username) async {
    // Obtém o banco de dados
    Database db = await database;
    // Consulta o banco de dados com base no nome de usuário fornecido
    List<Map> maps = await db.query(table, columns: [columnId, columnUsername, columnPassword], where: '$columnUsername = ?', whereArgs: [username]);
    // Verifica se a lista de resultados não está vazia e retorna o primeiro usuário encontrado
    if (maps.length > 0) {
      return User.fromMap(maps.first.cast<String, dynamic>());
    }
    // Retorna nulo se nenhum usuário for encontrado
    return null;
  }

  // Método para atualizar a senha do usuário com base no nome de usuário
  Future<int> updatePassword(String username, String newPassword) async {
    // Obtém o banco de dados
    Database db = await database;
    // Atualiza a senha do usuário com a nova senha fornecida
    return await db.update(table, {'password': newPassword}, where: '$columnUsername = ?', whereArgs: [username]);
  }

  // Método para atualizar um usuário no banco de dados
  Future<int> update(User user) async {
    // Obtém o banco de dados
    Database db = await database;
    // Atualiza os detalhes do usuário com base no ID fornecido
    return await db.update(table, user.toMap(), where: '$columnId = ?', whereArgs: [user.id]);
  }

  // Método para excluir um usuário do banco de dados com base no ID
  Future<int> delete(int id) async {
    // Obtém o banco de dados
    Database db = await database;
    // Exclui o usuário com o ID fornecido
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Método para verificar se um usuário já existe com base no nome de usuário
  Future<bool> checkIfUserExists(String username) async {
    // Obtém o banco de dados
    final db = await database;
    // Consulta o banco de dados para ver se o nome de usuário fornecido já existe
    final result = await db.query(table, where: '$columnUsername = ?', whereArgs: [username]);
    // Retorna verdadeiro se o resultado da consulta não estiver vazio
    return result.isNotEmpty;
  }

  // Método para consultar todos os usuários do banco de dados
  Future<List<User>> queryAllUsers() async {
    // Obtém o banco de dados
    Database db = await database;
    // Consulta todos os usuários no banco de dados
    List<Map> results = await db.query(table);
    // Mapeia os resultados para a lista de objetos de usuário e os retorna
    return results.map((map) => User.fromMap(map.cast<String, dynamic>())).toList();
  }
}
