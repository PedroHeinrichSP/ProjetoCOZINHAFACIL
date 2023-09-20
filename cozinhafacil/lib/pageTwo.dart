import 'package:flutter/material.dart';

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cozinha Fácil'),
        actions: <Widget>[
          // Adicione os ícones desejados aqui
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Adicione a lógica para a ação do ícone aqui
              // Por exemplo, abra uma barra de pesquisa
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list_alt),
            onPressed: () {
              // Adicione a lógica para a ação do ícone aqui
              // Por exemplo, abra uma barra de pesquisa
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Página 2'),
      ),
    );
  }
}

