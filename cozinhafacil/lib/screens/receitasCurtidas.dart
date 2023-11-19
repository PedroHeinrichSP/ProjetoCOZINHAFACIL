
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class RecipeCurtida {
  
  late String recipeId;
  late String title;
  late String description;
  late String prepTime;
  late int? servings;
  late List<String> ingredients;
  late List<String> steps;
  late String imageUrl;
  late int uniqueLikesCount;

  RecipeCurtida({
    required this.recipeId,
    required this.title,
    required this.description,
    required this.prepTime,
    required this.servings,
    required this.ingredients,
    required this.steps,
    required this.imageUrl,
    required this.uniqueLikesCount,
  });
}

class ReceitasCurtidasPage extends StatefulWidget {
  final String userId;

  ReceitasCurtidasPage({required this.userId});

  @override
  _ReceitasCurtidasPageState createState() => _ReceitasCurtidasPageState();
}

class _ReceitasCurtidasPageState extends State<ReceitasCurtidasPage> {
  late List<RecipeCurtida> receitasCurtidas;

  @override
  void initState() {
    super.initState();
    receitasCurtidas = [];
    fetchCurtidas();
  }

  Future<void> fetchCurtidas() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('likes', arrayContains: widget.userId)
        .get();

    setState(() {
      receitasCurtidas = _getRecipesFromQuery(snapshot);
    });
  }

  List<RecipeCurtida> _getRecipesFromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

      if (data == null) {
        return RecipeCurtida(
          recipeId: '',
          title: '',
          description: '',
          prepTime: '',
          servings: 0,
          ingredients: [],
          steps: [],
          imageUrl: '',
          uniqueLikesCount: 0,
        );
      }

      List<String> likes = List<String>.from(data['likes'] ?? []);
      int uniqueLikesCount = likes.toSet().length;

      return RecipeCurtida(
        recipeId: document.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        prepTime: data['prepTime'] ?? '',
        servings: data['servings'] ?? 0,
        ingredients: List<String>.from(data['ingredients'] ?? []),
        steps: List<String>.from(data['steps'] ?? []),
        imageUrl: data['imageUrl'] ?? '',
        uniqueLikesCount: uniqueLikesCount,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receitas Curtidas'),
        backgroundColor: Colors.brown[200],
      ),
      body: receitasCurtidas.isEmpty
          ? Center(
              child: Text(
                'Você ainda não curtiu nenhuma receita.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView(
              children: receitasCurtidas.map((RecipeCurtida receita) {
                return ListTile(
                  title: Text(receita.title),
                  subtitle: Text(receita.description),
                  onTap: () {
                    _navigateToDetalhesReceita(context, receita);
                  },
                );
              }).toList(),
            ),
    );
  }

  void _navigateToDetalhesReceita(BuildContext context, RecipeCurtida receita) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesReceitaPage(receita: receita),
      ),
    );
  }
}

class DetalhesReceitaPage extends StatelessWidget {
  final RecipeCurtida receita;

  DetalhesReceitaPage({required this.receita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Receita'),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: NetworkImage(receita.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receita.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    receita.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
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
                  for (var ingredient in receita.ingredients)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check, color: Colors.brown[700], size: 16),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Modo de Preparo:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    receita.steps.join('\n'),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}