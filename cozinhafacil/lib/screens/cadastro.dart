import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register(BuildContext context) {
    String email = _emailController.text;
    String password = _passwordController.text;

    _auth.createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      // Handle success, user is registered in Firebase Authentication.
      _showDialog(context, "Usuário registrado com sucesso. ID: ${userCredential.user!.uid}");
    }).catchError((error) {
      // Handle error.
      String errorMessage = _getErrorMessage(error);
      _showDialog(context, errorMessage);
    });
  }

  String _getErrorMessage(dynamic error) {
    String errorMessage = 'Ocorreu um erro ao registrar o usuário.';

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'weak-password':
          errorMessage = 'A senha é muito fraca. Por favor, escolha uma senha mais segura.';
          break;
        case 'email-already-in-use':
          errorMessage = 'O e-mail já está em uso. Tente fazer login ou use outro e-mail.';
          break;
        case 'invalid-email':
          errorMessage = 'O e-mail fornecido não é válido.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'O método de registro não está habilitado. Entre em contato com o suporte.';
          break;
        default:
          errorMessage = 'Erro ao registrar usuário: ${error.message}';
          break;
      }
    }

    return errorMessage;
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registro de Usuário'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
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
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _register(context),
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
