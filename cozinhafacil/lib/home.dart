import 'package:cozinhafacil/receita.dart';
import 'package:flutter/material.dart';

class CardGrid extends StatelessWidget {
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
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          CardWidget(
            imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
            title: 'Card 1',
            description: 'Descrição do Card 1',
          ),
          CardWidget(
            imageUrl: 'https://static.wixstatic.com/media/05cec1_99c80856b3c04b50b98885727b0e34e2~mv2.jpg/v1/fill/w_640,h_640,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/05cec1_99c80856b3c04b50b98885727b0e34e2~mv2.jpg',
            title: 'Cookie',
            description: 'Receita Cookie',
          ),
          CardWidget(
            imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
            title: 'Card 1',
            description: 'Descrição do Card 1',
          ),
          CardWidget(
            imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
            title: 'Card 1',
            description: 'Descrição do Card 1',
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatefulWidget {
  final String imageUrl;
  final String description;
  final String title;

  CardWidget({required this.imageUrl, required this.title, required this.description});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = isFavorite ? Colors.red : Colors.black;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DefaultCard(widget.imageUrl, widget.description, widget.title),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              height: 90.0,
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: IconButton(
                icon: Icon(Icons.favorite, color: iconColor),
                onPressed: () {
                  toggleFavorite();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
