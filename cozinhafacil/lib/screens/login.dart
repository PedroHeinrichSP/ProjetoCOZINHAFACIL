import 'package:cozinhafacil/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'perfil.dart';
import 'DatabaseHelper.dart';

class LoginScreen extends StatelessWidget {

  Future<void> _handleLogin(BuildContext context) async {
      // Fetch the user from the database
      var user = await DatabaseHelper.instance.fetchUser(
        _loginUsernameController.text,
        _loginPasswordController.text
      );

      // Check if user was found
      if (user != null) {
        // Successful login
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login bem-sucedido'),
            content: Text('Bem-vindo, ${user['username']}!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        // Failed login
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Falha no login'),
            content: Text('Nome de usuário ou senha incorretos!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }


  final _loginUsernameController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0), // Espaço ao redor do texto
                child: Text(
                  'Olá,\nBem vindo!',
                  style: TextStyle(
                    
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextField(
                  
                 
                  decoration: InputDecoration(
                    labelText: 'Nome de Usuário',
                  ),
                ),
              ),
              PasswordTextField(),
              Padding(
                padding: const EdgeInsets.only(left: 16, right:16, bottom: 32),
                child: ElevatedButton(
                onPressed: () async {  // torna o método assíncrono
      _handleLogin(context);
    
      var user = await DatabaseHelper.instance.fetchUser(
        _loginUsernameController.text,
        _loginPasswordController.text
      );

      // Check if user was found
      if (user != null) {
        // Successful login
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Login bem-sucedido'),
                  content: Text('Bem-vindo, ${user['username']}!'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            } else {
              // Failed login
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Falha no login'),
                  content: Text('Nome de usuário ou senha incorretos!'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            } 
            },
                child: Text('Login'),
              ),

                ),
              InkWell(
                onTap: () {
                  // Navegar para a tela de cadastro quando pressionar o texto
                  Navigator.pushNamed(context, '/cadastro');
                },
                child: const Text(
                  'Primeira vez por aqui?\nCadastre-se',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class PasswordTextField extends StatefulWidget{
  const PasswordTextField({super.key});

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}
class _PasswordTextFieldState extends State<PasswordTextField> {
  TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;//Track password is visible or not

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
        child: TextField(
          obscureText: _isObscured,
          decoration: InputDecoration(
            labelText: 'Senha',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured; // Toggle the value of _isObscured
                });
              },
              icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
            ),
          ),
          enableSuggestions: false,
        ),
    );
  }


}

