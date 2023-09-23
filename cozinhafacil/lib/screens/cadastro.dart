import 'package:flutter/material.dart';
class CadastroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Cadastro'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nome de Usuário',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
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
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

