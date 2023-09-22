import 'package:flutter/material.dart';

enum CardType {
  Todas,
  Italiano,
  Frances,
  Japonesa,
  Favoritas,
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
      description: 'Spaghetti à Bolonhesa',
      title: 'Spaghetti à Bolonhesa',
    ),
    CardData(
      type: CardType.Italiano,
      imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
      description: 'Pizza Margherita',
      title: 'Pizza Margherita',
    ), 
    CardData(
      type: CardType.Italiano,
      imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
      description: 'Lasanha à Bolonhesa',
      title: 'Lasanha à Bolonhesa',
    ),
    
    CardData(
      type: CardType.Frances,
      imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
      description: 'Croissant de Chocolate',
      title: 'Croissant de Chocolate',
    ),
    CardData(
      type: CardType.Frances,
      imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
      description: 'Sopa de Cebola',
      title: 'Sopa de Cebola',
    ),
    CardData(
      type: CardType.Japonesa,
      imageUrl: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
      description: 'Sushi de Salmão',
      title: 'Sushi de Salmão',
    ),
    // Adicione mais cards aqui com tipos diferentes
  ];

  List<CardData> filteredCards = [];
  CardType selectedType = CardType.Todas;

  @override
  void initState() {
    super.initState();
    filterCards();
  }

  void filterCards() {
    filteredCards.clear();
    if (selectedType == CardType.Todas) {
      filteredCards.addAll(allCards);
    } else if (selectedType == CardType.Favoritas) {
      filteredCards.addAll(allCards.where((card) => card.isFavorite));
    } else {
      filteredCards.addAll(allCards.where((card) => card.type == selectedType));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Receitas'),
        actions: [
          PopupMenuButton<CardType>(
            itemBuilder: (context) {
              return CardType.values.map((type) {
                return PopupMenuItem<CardType>(
                  value: type,
                  child: Text(type.toString().split('.')[1]),
                );
              }).toList();
            },
            onSelected: (type) {
              setState(() {
                selectedType = type;
              });
              filterCards();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Filtros:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: CardType.values.map((type) {
              return FilterChip(
                label: Text(type.toString().split('.')[1]),
                selected: selectedType == type,
                onSelected: (selected) {
                  setState(() {
                    selectedType = type;
                  });
                  filterCards();
                },
              );
            }).toList(),
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
                  padding: EdgeInsets.all(16.0),
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  children: filteredCards.map((card) {
                    return CardWidget(
                      cardData: card,
                      cardWidth: cardWidth,
                      onFavoriteChanged: () {
                        // Atualizar a lista de favoritos
                        filterCards();
                      },
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

class CardWidget extends StatefulWidget {
  final CardData cardData;
  final double cardWidth;
  final VoidCallback? onFavoriteChanged;

  CardWidget({
    required this.cardData,
    required this.cardWidth,
    this.onFavoriteChanged,
  });

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
              cardData: widget.cardData,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.only(top:8, left: 8, right: 8, bottom: 16),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: widget.cardData.title,
                child: Image.network(
                  widget.cardData.imageUrl,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                widget.cardData.title,
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
                widget.cardData.description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: widget.cardData.isFavorite
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(Icons.favorite_border),
              onPressed: () {
                setState(() {
                  widget.cardData.isFavorite = !widget.cardData.isFavorite;
                });
                if (widget.onFavoriteChanged != null) {
                  widget.onFavoriteChanged!();
                }
              },
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
  bool isFavorite;

  CardData({
    required this.type,
    required this.imageUrl,
    required this.description,
    required this.title,
    this.isFavorite = false,
  });
}

class RecipeDetailScreen extends StatelessWidget {
  final CardData cardData;

  RecipeDetailScreen({
    required this.cardData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cardData.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: cardData.title,
              child: Image.network(
                cardData.imageUrl,
                fit: BoxFit.fill,
                ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Descrição:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(cardData.description),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: CardGrid(),
    ));