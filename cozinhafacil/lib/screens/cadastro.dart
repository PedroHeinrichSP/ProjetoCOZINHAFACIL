import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'user_model.dart';
import 'perfil.dart';
import 'package:cozinhafacil/utils/pallete.dart';


class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

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
                Navigator.of(context).pop();
                if (message == "Cadastro bem-sucedido!") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PerfilScreen(
                        username: _usernameController.text,
                        password: _passwordController.text,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

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
        title: Text('Cadastro',
        style: TextStyle(
      color: AppColors.textColor, // Define a cor do texto),
      ))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Faça seu cadastro e adicione suas receitas!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20.0), // Espaço adicionado
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.buttonSecondaryColor),
                ),
                child: Text("Registrar"),
                onPressed: () async {
                  if (_validateFields()) {
                    User newUser = User(
                      username: _usernameController.text,
                      password: _passwordController.text,
                    );
                    int id = await DatabaseHelper.instance.insert(newUser);
                    if (id > 0) {
                      _showAlertDialog(context, "Cadastro bem-sucedido!");
                    } else if (id == -1) {
                      _showAlertDialog(context, "Usuário já existe.");
                    } else {
                      _showAlertDialog(context, "Falha no cadastro!");
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
