import 'package:cozinhafacil/utils/pallete.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       iconTheme: const IconThemeData(
          color: AppColors.textColor, // Define a cor do ícone (seta de voltar)
        ),
        title: const Text(
          'Pesquisa',
          style: TextStyle(
            color: AppColors.textColor, // Define a cor do texto da AppBar como preto
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: const Center(
        child: Text('Página de pesquisa TODO'),
      ),
    );
  }
}