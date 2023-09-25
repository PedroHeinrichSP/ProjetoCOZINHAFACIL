import 'package:flutter/material.dart';
import 'package:cozinhafacil/utils/pallete.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  bool _showPassword = false; // Variável para controlar a visibilidade da senha

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Usar a CustomAppBar personalizada
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Olá,\nBem vindo!',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Alinha o texto ao centro
              ),
              SizedBox(height: 35.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nome de Usuário',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                obscureText: !_showPassword, // Oculta a senha com base no valor de _showPassword
                decoration: InputDecoration(
                  labelText: 'Senha',
                  // Adiciona o ícone de "olho" para mostrar/ocultar a senha
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword; // Alterna a visibilidade da senha
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                obscureText: !_showPassword, // Oculta a senha com base no valor de _showPassword
                decoration: InputDecoration(
                  labelText: 'Confirme a Senha',
                  // Adiciona o ícone de "olho" para mostrar/ocultar a senha
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword; // Alterna a visibilidade da senha
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // Lógica de cadastro aqui
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Cadastro concluído'),
                        content: Text('Você está cadastrado!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
                              style: TextStyle(
                                color: Color.fromARGB(255, 74, 96, 78),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56.0); // Altura da AppBar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      iconTheme: IconThemeData(
        color: AppColors.textColor, // Define a cor do ícone (seta de voltar)
      ),
      title: const Text(
        'Tela de Cadastro',
        style: TextStyle(
          color: AppColors.textColor, // Define a cor do texto da AppBar como preto
        ),
      ),
    );
  }
}
