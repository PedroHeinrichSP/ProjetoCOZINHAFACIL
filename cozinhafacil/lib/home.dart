import 'package:flutter/material.dart';

import 'receita.dart';

enum CardType {
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
    // Adicione mais cards aqui com tipos diferentes
  ];

  List<CardData> filteredCards = [];
  CardType selectedType = CardType.Italiano; // Tipo padrão selecionado

  @override
  void initState() {
    super.initState();
    filterCards();
  }

  void filterCards() {
    filteredCards.clear();
    filteredCards.addAll(allCards.where((card) => card.type == selectedType));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              DropdownButton<CardType>(
                value: selectedType,
                items: CardType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.')[1]), // Remove o prefixo 'CardType.'
                        ))
                    .toList(),
                onChanged: (type) {
                  setState(() {
                    selectedType = type!;
                  });
                  filterCards();
                },
              ),
            ],
          ),
        ),
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DefaultCard(this.imageUrl, this.description, this.title)));
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
