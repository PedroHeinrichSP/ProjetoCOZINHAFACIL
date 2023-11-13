import 'package:flutter/material.dart';
import 'cadastro.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    String email = _emailController.text;
    String password = _passwordController.text;

    _auth.signInWithEmailAndPassword(email: email, password: password).then((userCredential) {
      _showDialog(context, "Login bem-sucedido. ID: ${userCredential.user!.uid}");
      // Redirecione para a próxima tela ou realize a ação desejada após o login
    }).catchError((error) {
      String errorMessage = _getErrorMessage(error);
      _showDialog(context, errorMessage);
    });
  }

  String _getErrorMessage(dynamic error) {
    String errorMessage = 'Ocorreu um erro ao tentar fazer login.';

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          errorMessage = 'E-mail fornecido não é válido.';
          break;
        case 'user-not-found':
          errorMessage = 'Usuário não encontrado. Verifique o e-mail informado.';
          break;
        case 'wrong-password':
          errorMessage = 'Senha incorreta. Verifique sua senha e tente novamente.';
          break;
        case 'user-disabled':
          errorMessage = 'A conta de usuário foi desabilitada. Entre em contato com o suporte.';
          break;
        default:
          errorMessage = 'Erro no login. Verifique sua email/senha e tente novamente. ';
          break;
      }
    }

    return errorMessage;
  }

  void _navigateToCadastro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login'),
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
        title: Text('Login'),
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
              onPressed: () => _login(context),
              child: Text('Entrar'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _navigateToCadastro(context),
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
