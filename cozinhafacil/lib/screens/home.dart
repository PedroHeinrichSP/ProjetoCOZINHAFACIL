import 'package:cozinhafacil/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'receitas_api.dart';
import 'favorite.dart';
import 'SearchScreen.dart';

void main() => runApp(MaterialApp(
      home: CardGrid(),
    ));

// Enum para representar os tipos de cartões
enum CardType {
  african,
  asian,
  american,
  british,
  cajun,
  caribbean,
  chinese,
  easterneuropean,
  european,
  french,
  german,
  greek,
  indian,
  irish,
  italian,
  japanese,
  jewish,
  korean,
  latinamerican,
  mediterranean,
  mexican,
  middleeastern,
  nordic,
  southern,
  spanish,
  thai,
  vietnamese,
}

// Classe para representar os dados do cartão
class CardData {
  final CardType type;
  final String imageUrl;
  final String description;
  final String title;
  final int id;
  bool isFavorite;

  CardData({
    required this.type,
    required this.imageUrl,
    required this.description,
    required this.title,
    required this.id,
    this.isFavorite = false,
  });
}

class CardGrid extends StatefulWidget {
  @override
  _CardGridState createState() => _CardGridState();
}

class _CardGridState extends State<CardGrid> {
  List<CardData> allCards = [];
  CardType selectedType = CardType.african;

  @override
  void initState() {
    super.initState();
    fetchRecipesByType(selectedType);
  }

  // Função para buscar receitas por tipo
  Future<void> fetchRecipesByType(CardType foodType) async {
    final apiKey = ' 3edb49a3da53419d9d1bd0e349cf735c';
    final typeParam = '&cuisine=${foodType.toString().split('.')[1]}';
    final apiUrl =
        'https://api.spoonacular.com/recipes/complexSearch?cuisine=${foodType.toString().split('.')[1]}&number=20&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final recipes = data['results'];

        setState(() {
          allCards.clear();

          for (var recipe in recipes) {
            allCards.add(CardData(
              type: foodType,
              imageUrl: recipe['image'],
              description: recipe['title'],
              title: recipe['title'],
              id: recipe['id'],
            ));
          }
        });
      } else {
        print('Erro na solicitação: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na conexão: $e');
    }
  }

  // Função para alternar o status "favorito" de um cartão
  void _toggleFavorite(int id) {
    setState(() {
      final recipe = allCards.firstWhere((card) => card.id == id);
      recipe.isFavorite = !recipe.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              color: AppColors.buttonPrimaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen()),
                  );
              },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            color: AppColors.buttonPrimaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritasScreen(allCards, toggleFavorite: _toggleFavorite),
                ),
              );
            },
          ),
          //icone do filtro aqui
         PopupMenuButton<CardType>(
        icon: const Icon(
            Icons.filter_alt,
            color: AppColors.buttonPrimaryColor, // Cor do icone
          ),
        onSelected: (CardType type) {
          setState(() {
            selectedType = type;
          });
          fetchRecipesByType(selectedType);
        },
        itemBuilder: (BuildContext context) => CardType.values.map((type) {
          return PopupMenuItem<CardType>(
            value: type,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.restaurant_menu,
                  color: selectedType == type ? AppColors.buttonPrimaryColor : Colors.grey,
                ),
                SizedBox(width: 8.0),
                Text(
                  type.toString().split('.')[1],
                  style: TextStyle(
                    color: selectedType == type ? AppColors.buttonPrimaryColor  : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),

        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;
                double cardWidth;

                // Calcula o número de colunas e a largura do cartão com base na largura da tela
                if (screenWidth >= 600) {
                  crossAxisCount = 3;
                  cardWidth = (screenWidth - 32.0 - (crossAxisCount - 1) * 16.0) / crossAxisCount;
                } else {
                  crossAxisCount = 2;
                  cardWidth = (screenWidth - 32.0 - (crossAxisCount - 1) * 16.0) / crossAxisCount;
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                  ),
                  padding: EdgeInsets.all(16.0),
                  itemCount: allCards.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CardWidget(
                      cardData: allCards[index],
                      cardWidth: cardWidth,
                      toggleFavorite: _toggleFavorite,
                    );
                  },
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
  final Function(int) toggleFavorite;

  CardWidget({
    required this.cardData,
    required this.cardWidth,
    required this.toggleFavorite,
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
              toggleFavorite: widget.toggleFavorite,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(8.0),
        color: AppColors.cardColor,
        child: ListView( // Use ListView para tornar o conteúdo rolável
          shrinkWrap: true,
          children: <Widget>[
            Hero(
              tag: widget.cardData.title,
              child: Image.network(
                widget.cardData.imageUrl,
                fit: BoxFit.cover,
                width: widget.cardWidth,
                height: 150.0,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                widget.cardData.title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                widget.cardData.description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
            FavoriteButton(
              isFavorite: widget.cardData.isFavorite,
              toggleFavorite: () {
                widget.toggleFavorite(widget.cardData.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class ConfiguracoesScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Configurações'),
//         backgroundColor: AppColors.primaryColor,
//       ),
//       body: Center(
//         child: Text('Página de Configurações'),
//       ),
//     );
//   }
// }



class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final Function toggleFavorite;

  FavoriteButton({required this.isFavorite, required this.toggleFavorite});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: () {
        toggleFavorite();
      },
    );
  }
}
