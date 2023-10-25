import 'package:cozinhafacil/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'user_model.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  // Função para mostrar a caixa de diálogo
  Future<void> _showAlertDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultado do Cadastro'),
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
                Navigator.of(context).pop(); // Fecha a caixa de diálogo
                if (message == "Cadastro bem-sucedido!") {
                  Navigator.of(context).pop(); // Volta para a tela de login
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Função para validar os campos
  bool _validateFields() {
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showAlertDialog(context, "Por favor, preencha todos os campos.");
      return false;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      _showAlertDialog(context, "As senhas não coincidem.");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(
          color: AppColors.textColor,
        ),
        title: const Text(
          'Cadastro',
          style: TextStyle(
            color: AppColors.textColor,
          ),
        ),
      ),
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
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              // Campos de entrada para nome de usuário, senha e confirmação de senha
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  child: Text("Registrar"),
                  onPressed: () async {
                    if (_validateFields()) {
                      User newUser = User(
                        username: _usernameController.text,
                        password: _passwordController.text,
                      );
                      int id = await DatabaseHelper.instance.insert(newUser);
                      if (id > 0) {
                        // Cadastro bem-sucedido
                        _showAlertDialog(context, "Cadastro bem-sucedido!");
                      } else {
                        // Falha no cadastro
                        _showAlertDialog(context, "Falha no cadastro!");
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
