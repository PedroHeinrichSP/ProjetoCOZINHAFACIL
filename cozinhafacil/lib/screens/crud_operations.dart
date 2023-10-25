import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'user_model.dart';

// Classe StatefulWidget para operações CRUD
class CRUDOperations extends StatefulWidget {
  @override
  _CRUDOperationsState createState() => _CRUDOperationsState();
}

// Classe de estado para operações CRUD
class _CRUDOperationsState extends State<CRUDOperations> {
  List<User> users = []; // Lista de usuários

  // Método para obter todos os usuários do banco de dados
  void _getAllUsers() async {
    List<User> fetchedUsers = await DatabaseHelper.instance.queryAllUsers();
    setState(() {
      users = fetchedUsers; // Atualiza a lista de usuários
    });
  }

  // Método para adicionar um novo usuário
  void _addUser(User user) async {
    await DatabaseHelper.instance.insert(user);
    _getAllUsers(); // Obtém todos os usuários após a adição
  }

  // Método para atualizar um usuário existente
  void _updateUser(User user) async {
    await DatabaseHelper.instance.update(user);
    _getAllUsers(); // Obtém todos os usuários após a atualização
  }

  // Método para excluir um usuário existente
  void _deleteUser(int id) async {
    await DatabaseHelper.instance.delete(id);
    _getAllUsers(); // Obtém todos os usuários após a exclusão
  }

  // Método para exibir um diálogo para adicionar ou editar um usuário
  Future<void> _showDialog(User? user) async {
    bool isEditing = user != null; // Verifica se está editando ou adicionando
    User newUser = isEditing ? user! : User(username: '', password: ''); // Cria um novo usuário se estiver adicionando
    TextEditingController _usernameController = TextEditingController(text: newUser.username);
    TextEditingController _passwordController = TextEditingController(text: newUser.password);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Usuário' : 'Adicionar Usuário'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                setState(() {
                  newUser.username = _usernameController.text;
                  newUser.password = _passwordController.text;
                  if (isEditing) {
                    _updateUser(newUser);
                  } else {
                    _addUser(newUser);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Operations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _getAllUsers, // Obtém todos os usuários ao pressionar o botão
              child: Text('Listar Todos os Usuários'),
            ),
            SizedBox(height: 20),
            Text(
              'Usuários:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Username: ${users[index].username}, Password: ${users[index].password}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showDialog(users[index]); // Exibe o diálogo de edição
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteUser(users[index].id!); // Deleta o usuário ao pressionar o ícone de lixeira
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adicionar operação de adição de usuário aqui
          _showDialog(null); // Exibe o diálogo para adicionar um novo usuário
        },
        child: Icon(Icons.add), // Ícone de adição no botão flutuante
      ),
    );
  }
}
