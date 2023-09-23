import 'package:cozinhafacil/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';

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
      appBar:
        AppBar(title: Text(widget.cardData.title)),
        backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.cardData.title,
              child: Image.network(
                widget.cardData.imageUrl,
                fit: BoxFit.cover,
                height: 200.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Descrição:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            Text(
              widget.cardData.description,
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Instruções:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            loading
                ? CircularProgressIndicator()
                : (instructions != null
                    ? Text(
                        instructions!,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: AppColors.textColor,
                        ),
                      )
                    : Text(
                        'Instruções não encontradas.',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: AppColors.textColor,
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
                color: AppColors.textColor,
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
                              color: AppColors.textColor,
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
                      color: AppColors.textColor,
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
                              color: AppColors.textColor,
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
                      color: AppColors.textColor,
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
                color: AppColors.textColor,
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