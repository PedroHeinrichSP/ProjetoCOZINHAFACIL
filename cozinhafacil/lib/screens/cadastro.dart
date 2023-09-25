import 'package:flutter/material.dart';
import 'package:cozinhafacil/utils/pallete.dart';
class CadastroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                            child:Text('OK',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 74, 96, 78),
                                  fontWeight: FontWeight.bold, // Adicione esta linha para tornar o texto negrito
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

