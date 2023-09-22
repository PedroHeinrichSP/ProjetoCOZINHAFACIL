import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final apiKey = '3b1bb549168f47e9b8e62bc67bd0123d';
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
        title: Text('Receitas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritasScreen(allCards, toggleFavorite: _toggleFavorite),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfiguracoesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Dropdown para selecionar o tipo de cartão
          DropdownButton<CardType>(
            value: selectedType,
            onChanged: (CardType? newValue) {
              setState(() {
                selectedType = newValue!;
                fetchRecipesByType(selectedType);
              });
            },
            items: CardType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.')[1]),
              );
            }).toList(),
          ),
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
        margin: EdgeInsets.only(top:8, left: 8, right: 8, bottom: 16),
        color: Colors.white,
        child: ListView( // Use ListView para tornar o conteúdo rolável
          shrinkWrap: true,
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
                maxLines: 2,
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

class RecipeDetailScreen extends StatefulWidget {
  final CardData cardData;
  final Function(int) toggleFavorite;

  RecipeDetailScreen({
    required this.cardData,
    required this.toggleFavorite,
  });

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  String? instructions;
  String? vegetarian;
  List<String>? dishTypes;
  List<String>? extendedIngredients;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails();
  }

  // Função para buscar detalhes da receita
  Future<void> fetchRecipeDetails() async {
    final apiKey = '3b1bb549168f47e9b8e62bc67bd0123d';
    final recipeId = widget.cardData.id.toString();
    final apiUrl =
        'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          instructions = data['instructions'];
          vegetarian = data['vegetarian'] ? 'Sim' : 'Não';
          dishTypes = List<String>.from(data['dishTypes']);
          extendedIngredients = List<String>.from(data['extendedIngredients']
              .map((ingredient) => ingredient['original']));
          loading = false; // Indicar que o carregamento está completo
        });
      } else {
        print('Erro na solicitação: ${response.statusCode}');
        setState(() {
          loading = false; // Indicar que o carregamento está completo, mesmo em caso de erro
        });
      }
    } catch (e) {
      print('Erro na conexão: $e');
      setState(() {
        loading = false; // Indicar que o carregamento está completo, mesmo em caso de erro
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cardData.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.cardData.title,
              child: Image.network(
            apiConectada
                widget.cardData.imageUrl,
                fit: BoxFit.cover,
                height: 200.0,
              ),
                cardData.imageUrl,
                fit: BoxFit.fill,
                ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Descrição:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              widget.cardData.description,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Instruções:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            loading
                ? CircularProgressIndicator()
                : (instructions != null
                    ? Text(
                        instructions!,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                        ),
                      )
                    : Text(
                        'Instruções não encontradas.',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                        ),
                      )),
            SizedBox(height: 16.0),
            Text(
              'Vegetariana:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              vegetarian ?? 'Desconhecido',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Tipos de Prato:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            dishTypes != null
                ? Column(
                    children: dishTypes!.map((dishType) {
                      return Row(
                        children: [
                          Icon(Icons.local_dining, color: Colors.green),
                          SizedBox(width: 8.0),
                          Text(
                            dishType,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  )
                : Text(
                    'Desconhecido',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
            SizedBox(height: 16.0),
            Text(
              'Ingredientes:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            extendedIngredients != null
                ? Column(
                    children: extendedIngredients!.map((ingredient) {
                      return Row(
                        children: [
                          Icon(Icons.shopping_cart, color: Colors.blue),
                          SizedBox(width: 8.0),
                          Text(
                            ingredient,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  )
                : Text(
                    'Desconhecido',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
            SizedBox(height: 16.0),
            Text(
              'Tipo de Comida:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              widget.cardData.type.toString().split('.')[1],
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.0),
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

class FavoritasScreen extends StatelessWidget {
  final List<CardData> allCards;
  final Function(int) toggleFavorite;

  FavoritasScreen(this.allCards, {required this.toggleFavorite});

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = allCards.where((card) => card.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritas'),
      ),
      body: ListView.builder(
        itemCount: favoriteRecipes.length,
        itemBuilder: (BuildContext context, int index) {
          final card = favoriteRecipes[index];
          return CardWidget(
            cardData: card,
            cardWidth: 300.0,
            toggleFavorite: toggleFavorite,
          );
        },
      ),
    );
  }
}

class ConfiguracoesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Center(
        child: Text('Página de Configurações'),
      ),
    );
  }
}

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
