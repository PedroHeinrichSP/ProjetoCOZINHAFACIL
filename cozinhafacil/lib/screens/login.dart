import 'package:flutter/material.dart';
import 'package:cozinhafacil/screens/perfil.dart';
import 'database_helper.dart';
import 'user_model.dart';
import 'package:cozinhafacil/screens/cadastro.dart';
import 'crud_operations.dart'; // Importando a página com operações CRUD

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Função para exibir um AlertDialog com uma mensagem
  Future<void> _showAlertDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultado do Login'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (message == "Login bem-sucedido!") {
                  _navigateToPerfil(); // Chama a função para navegar para a tela de perfil
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Função para navegar para a tela de perfil
  void _navigateToPerfil() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PerfilScreen(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Olá,\nBem-vindo',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Text("Login"),
                  onPressed: () async {
                    User? user = await DatabaseHelper.instance.queryUser(_usernameController.text);
                    if (user != null && user.password == _passwordController.text) {
                      _showAlertDialog("Login bem-sucedido!");
                    } else {
                      _showAlertDialog("Username ou senha incorretos!");
                    }
                  },
                ),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CadastroScreen()),
                  );
                },
                child: Text("Novo por aqui?\nCadastra-se"),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CRUDOperations()),
                  );
                },
                child: Text("CRUD"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
