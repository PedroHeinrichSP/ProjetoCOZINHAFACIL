import 'package:flutter/material.dart';
import 'sobrePage.dart';
import 'receita.dart'; // Importe o arquivo receita.dart aqui

void main() => runApp(MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List of recipe data
  List<RecipeItem> recipes = [
    RecipeItem(
      imageUrl: 'https://www.receitasnestle.com.br/sites/default/files/styles/recipe_detail_desktop/public/srh_recipes/16f8aff19e2a7db960e01ccab3901bfe.webp?itok=bKTLCjv4',
      title: 'Lasanha à Bolonhesa',
      description: 'Deliciosa lasanha com carne moída e molho de tomate.',
      isFavorite: false,
      prepTime: '1 hora',
      ingredients: ['Massa de lasanha', 'Carne moída', 'Molho de tomate', 'Queijo'],
      servings: '4 porções',
      instructions: 'Cozinhe a massa de lasanha e reserve. Refogue a carne moída, adicione o molho de tomate e monte as camadas da lasanha intercalando com queijo. Leve ao forno por 30 minutos.',
    ),
    RecipeItem(
      imageUrl: 'https://media.gettyimages.com/id/1332440669/pt/foto/raw-salmon-steak-in-grill-pan-salt-pepper-rosemary-olive-oil-and-garlic-on-rustic-oak-table.jpg?s=2048x2048&w=gi&k=20&c=nGEDkvr1gleG--WcyrPm61ElrUU8dfb3k8xM_YKgA6U=',
      title: 'Salmão Grelhado',
      description: 'Salmão grelhado com limão e ervas.',
      isFavorite: false,
      prepTime: '30 minutos',
      ingredients: ['Salmão', 'Limão', 'Sal', 'Pimenta', 'Ervas'],
      servings: '2 porções',
      instructions: 'Tempere o salmão com sal, pimenta e ervas a gosto. Grelhe o salmão em uma frigideira com azeite por 10 minutos de cada lado. Sirva com rodelas de limão.',
    ),
    RecipeItem(
      imageUrl: 'https://media.gettyimages.com/id/145632947/pt/foto/chocolate-cake.jpg?s=2048x2048&w=gi&k=20&c=40tN0JQdzVGfo6Bm_IHeV1IPb9uykHxNDLVhsJbR9es=',
      title: 'Bolo de Chocolate',
      description: 'Bolo de chocolate fofinho com cobertura de brigadeiro.',
      prepTime: '1 hora e 30 minutos',
      ingredients: ['Farinha de trigo', 'Açúcar', 'Chocolate em pó', 'Ovos', 'Leite', 'Fermento', 'Leite condensado', 'Manteiga'],
      servings: '8 porções',
      instructions: 'Bata os ingredientes do bolo no liquidificador e asse em forno preaquecido a 180 graus por 40 minutos. Para a cobertura, misture o leite condensado, chocolate em pó e manteiga em fogo baixo até obter o ponto de brigadeiro. Cubra o bolo com a cobertura ainda quente.',
    ),
    // Add more items as needed
  ];

  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color.fromARGB(255, 41, 41, 41), Colors.transparent]),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              // Handle search button tap
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            color: Colors.white,
            onPressed: () {
              // Handle "Sobre" button tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SobrePage()),
              );
            },
          ),
        ],
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        allowImplicitScrolling: true,
        controller: _pageController,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeCard(recipe: recipe);
        },
        onPageChanged: (index) {
          // Handle page change, you can add logic here if needed
        },
      ),
    );
  }
}

class RecipeCard extends StatefulWidget {
  final RecipeItem recipe;

  RecipeCard({required this.recipe});

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DefaultCard(
              widget.recipe.imageUrl,
              widget.recipe.description,
              widget.recipe.title,
              widget.recipe.prepTime,
              widget.recipe.ingredients,
              widget.recipe.servings,
              widget.recipe.instructions,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.recipe.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(208, 59, 59, 59).withOpacity(0.7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.recipe.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.recipe.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.recipe.isFavorite = !widget.recipe.isFavorite;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        widget.recipe.isFavorite ? Colors.red : Colors.white,
                  ),
                  child: Icon(
                    widget.recipe.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        widget.recipe.isFavorite ? Colors.white : Colors.red,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeItem {
  final String imageUrl;
  final String title;
  final String description;
  bool isFavorite;
  final String prepTime;
  final List<String> ingredients;
  final String servings;
  final String instructions;

  RecipeItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.prepTime,
    required this.ingredients,
    required this.servings,
    required this.instructions,
    this.isFavorite = false,
  });
}
