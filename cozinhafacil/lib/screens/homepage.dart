import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Recipe {
  late String recipeId;
  late String title;
  late String description;
  late String prepTime;
  late int? servings;
  late List<String> ingredients;
  late List<String> steps;
  late String imageUrl;
  List<String>? likes;
  late int uniqueLikesCount;

  Recipe({
    required this.recipeId,
    required this.title,
    required this.description,
    required this.prepTime,
    required this.servings,
    required this.ingredients,
    required this.steps,
    required this.imageUrl,
    this.likes,
    required this.uniqueLikesCount,
  });
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onLikePressed;

  RecipeCard({required this.recipe, required this.onLikePressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsPage(recipe: recipe, onLikePressed: onLikePressed),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                recipe.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.thumb_up, color: Colors.brown),
                      SizedBox(width: 5),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('recipes').doc(recipe.recipeId).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text('Likes: ${recipe.uniqueLikesCount}', style: TextStyle(fontSize: 16, color: Colors.brown));
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}', style: TextStyle(fontSize: 16, color: Colors.brown));
                          }

                          var likes = snapshot.data?['likes'] ?? [];
                          int uniqueLikesCount = likes.toSet().length;
                          return Text('Likes: $uniqueLikesCount', style: TextStyle(fontSize: 16, color: Colors.brown));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: TextStyle(fontSize: 16, color: Colors.brown[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetailsPage extends StatefulWidget {
  final Recipe recipe;
  final VoidCallback onLikePressed;

  RecipeDetailsPage({required this.recipe, required this.onLikePressed});

  @override
  _RecipeDetailsPageState createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  late bool userLiked;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userLiked = user != null && (widget.recipe.likes?.contains(user.uid) ?? false);
  }

  Future<void> _handleLike(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String userId = user.uid;

      if (widget.recipe.likes?.contains(userId) ?? false) {
        await FirebaseFirestore.instance.collection('recipes').doc(widget.recipe.recipeId).update({
          'likes': FieldValue.arrayRemove([userId]),
        });

        setState(() {
          userLiked = false;
        });
      } else {
        await FirebaseFirestore.instance.collection('recipes').doc(widget.recipe.recipeId).update({
          'likes': FieldValue.arrayUnion([userId]),
        });

        setState(() {
          userLiked = true;
        });
      }

      widget.onLikePressed();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Você deve estar logado'),
            content: Text('Para curtir a receita, você precisa estar logado.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Receita'),
        backgroundColor: Colors.brown[200],
        actions: [
          if (userLiked)
            IconButton(
              icon: Icon(
                Icons.thumb_up,
                color: Color.fromARGB(255, 76, 50, 8),
              ),
              onPressed: () {
                _handleLike(context);
              },
            ),
          if (!userLiked)
            IconButton(
              icon: Icon(Icons.thumb_up_outlined),
              onPressed: () {
                _handleLike(context);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.recipe.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(Icons.access_time, color: Colors.brown[700]),
                    SizedBox(height: 5),
                    Text(
                      'Preparo: ${widget.recipe.prepTime}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Icon(Icons.local_dining, color: Colors.brown[700]),
                    SizedBox(height: 5),
                    Text(
                      'Porções: ${widget.recipe.servings}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                widget.recipe.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                widget.recipe.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingredientes:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  for (var ingredient in widget.recipe.ingredients)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.check, color: Colors.brown[700], size: 16),
                          SizedBox(width: 10),
                          Text(ingredient, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Modo de Preparo:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.recipe.steps.join('\n'),
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Recipe> recipes;

  @override
  void initState() {
    super.initState();
    recipes = [];
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('recipes').get();
    setState(() {
      recipes = _getRecipesFromQuery(snapshot);
    });
  }

  List<Recipe> _getRecipesFromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic>? data =
          document.data() as Map<String, dynamic>?;

      if (data == null) {
        return Recipe(
          recipeId: '',
          title: '',
          description: '',
          prepTime: '',
          servings: 0,
          ingredients: [],
          steps: [],
          imageUrl: '',
          likes: [],
          uniqueLikesCount: 0,
        );
      }

      List<String> likes = List<String>.from(data['likes'] ?? []);
      int uniqueLikesCount = likes.toSet().length;

      return Recipe(
        recipeId: document.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        prepTime: data['prepTime'] ?? '',
        servings: data['servings'] ?? 0,
        ingredients: List<String>.from(data['ingredients'] ?? []),
        steps: List<String>.from(data['steps'] ?? []),
        imageUrl: data['imageUrl'] ?? '',
        likes: likes,
        uniqueLikesCount: uniqueLikesCount,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receitas'),
        backgroundColor: Colors.brown[200],
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Sem Filtro'),
                value: 'none',
              ),
              PopupMenuItem(
                child: Text('Ordem alfabética'),
                value: 'alphabetical',
              ),
              PopupMenuItem(
                child: Text('Likes'),
                value: 'likes',
              ),
            ],
            onSelected: (value) {
              setState(() {
                if (value == 'none') {
                  fetchRecipes();
                } else if (value == 'alphabetical') {
                  recipes.sort((a, b) => a.title.compareTo(b.title));
                } else if (value == 'likes') {
                  recipes.sort((a, b) => b.uniqueLikesCount.compareTo(a.uniqueLikesCount));
                }
              });
            },
          ),
        ],
      ),
      body: ListView(
        children: recipes.map((Recipe recipe) {
          return RecipeCard(
            recipe: recipe,
            onLikePressed: () {
              fetchRecipes(); // Chamar fetchRecipes quando o botão "like" for pressionado
            },
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      primarySwatch: Colors.brown,
      hintColor: Colors.brown[700],
    ),
  ));
}