import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/puc_minas_logo.png', // Caminho para a imagem do logotipo da PUC Minas
                width: 350, // Largura da imagem
                height: 350, // Altura da imagem
              ),
              SizedBox(height: 20),
              Text(
                'Cozinha Fácil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Este é um aplicativo de culinária fácil que ajuda você a encontrar e compartilhar receitas deliciosas.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Versão: 1.0.0',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}