import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Perfil'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Informações do Perfil Aqui',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Navegar de volta para a tela de login
                  Navigator.of(context).pop();
                },
                child: Text('Voltar para o Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
