import 'package:flutter/material.dart';

import 'receita.dart';

enum CardType {
  Todos,
  Italiano,
  Frances,
  Japonesa,
}

class CardGrid extends StatefulWidget {
  @override
  _CardGridState createState() => _CardGridState();
}

class _CardGridState extends State<CardGrid> {
  List<CardData> allCards = [
    CardData(
      type: CardType.Italiano,
      imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
      description: 'Descrição do Card 1',
      title: 'Card 1',
    ),
    CardData(
      type: CardType.Italiano,
      imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
      description: 'Descrição do Card 2',
      title: 'Card 2',
    ), 
    CardData(
      type: CardType.Italiano,
      imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
      description: 'Descrição do Card 7',
      title: 'Card 7',
    ),
    
    CardData(
      type: CardType.Frances,
      imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
      description: 'Descrição do Card 3',
      title: 'Card 3',
    ),
    CardData(
      type: CardType.Frances,
      imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
      description: 'Descrição do Card 4',
      title: 'Card 4',
    ),
    CardData(
      type: CardType.Japonesa,
      imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
      description: 'Descrição do Card 5',
      title: 'Card 5',
    ),
  ];

  List<CardData> filteredCards = [];
  CardType selectedType = CardType.Todos; // Tipo padrão selecionado

  @override
  void initState() {
    super.initState();
    filterCards();
  }

  void filterCards() {
    if (selectedType == CardType.Todos) {
      // Se o filtro Todos estiver selecionado, mostre todos os cards
      filteredCards.clear();
      filteredCards.addAll(allCards);
    } else {
      // Caso contrário, filtre os cards com base no tipo selecionado
      filteredCards.clear();
      filteredCards.addAll(allCards.where((card) => card.type == selectedType));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cozinha Fácil'),
        actions: <Widget>[
          PopupMenuButton<CardType>(
            icon: Icon(Icons.filter_alt), // Ícone de filtro
            onSelected: (type) {
              setState(() {
                selectedType = type;
              });
              filterCards();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<CardType>>[
              PopupMenuItem<CardType>(
                value: CardType.Todos,
                child: Text('Todos'), // Opção de filtro "Todos"
              ),
              PopupMenuItem<CardType>(
                value: CardType.Italiano,
                child: Text('Italiano'), // Opção de filtro "Italiano"
              ),
              PopupMenuItem<CardType>(
                value: CardType.Frances,
                child: Text('Frances'), // Opção de filtro "Frances"
              ),
              PopupMenuItem<CardType>(
                value: CardType.Japonesa,
                child: Text('Japonesa'), // Opção de filtro "Japonesa"
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;
                double cardWidth;

                if (screenWidth >= 1200) {
                  crossAxisCount = 3;
                  cardWidth = screenWidth / 3 - 16.0;
                } else {
                  crossAxisCount = 2;
                  cardWidth = screenWidth / 2 - 16.0;
                }

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  padding: EdgeInsets.all(8.0),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  children: filteredCards.map((card) {
                    return CardWidget(
                      imageUrl: card.imageUrl,
                      description: card.description,
                      title: card.title,
                      cardWidth: cardWidth,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String imageUrl;
  final String description;
  final String title;
  final double cardWidth;

  CardWidget({
    required this.imageUrl,
    required this.description,
    required this.title,
    required this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
                Navigator.push(context, MaterialPageRoute(
          builder: (context) => DefaultCard(this.imageUrl, this.description, this.title)
        ));
      },
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(8.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: cardWidth,
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardData {
  final CardType type;
  final String imageUrl;
  final String description;
  final String title;

  CardData({
    required this.type,
    required this.imageUrl,
    required this.description,
    required this.title,
  });
}

