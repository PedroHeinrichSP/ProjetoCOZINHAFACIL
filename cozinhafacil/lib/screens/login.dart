import 'package:cozinhafacil/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'perfil.dart';

class LoginScreen extends StatelessWidget {
  //TODO every controller and login logic

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
                  'Olá\nBem vindo!',
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
                  onPressed: () {
                    // Lógica de autenticação aqui
                    // Por enquanto, apenas exibe uma mensagem de sucesso
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Login bem-sucedido'),
                          content: Text('Você está logado!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PerfilScreen()),
                                );
                              },
                              child: Text( 'OK',
                              style: TextStyle(
                                color: Color.fromARGB(255, 74, 96, 78),
                                fontWeight: FontWeight.bold, // Adicione esta linha para tornar o texto negrito
                              ),
                            )
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, 
                    backgroundColor: Color.fromARGB(255, 218, 175, 167), 
                  ),
                  child: Text('Entrar'),
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