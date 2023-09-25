import 'package:flutter/material.dart';
import 'sobrePage.dart';

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
      imageUrl: 'https://pbs.twimg.com/media/FuymTLpXoAQ_2qT.jpg:large',
      title: 'Recipe 1',
      description: 'Description for Recipe 1',
      isFavorite: false,
    ),
    RecipeItem(
      imageUrl:
          'https://media-cdn.tripadvisor.com/media/photo-s/19/6a/f1/a4/16-ninesixteenth.jpg',
      title: 'Recipe 2',
      description: 'Description for Recipe 2',
      isFavorite: false,
    ),
    RecipeItem(
      imageUrl:
          'https://miro.medium.com/v2/resize:fit:1200/1*dx1MHKoqVApb5_KCylBoew.jpeg',
      title: 'Recipe 3',
      description: 'Description for Recipe 3',
      isFavorite: false,
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
    return Container(
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
                  color: widget.recipe.isFavorite ? Colors.red : Colors.white,
                ),
                child: Icon(
                  widget.recipe.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.recipe.isFavorite ? Colors.white : Colors.red,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeItem {
  final String imageUrl;
  final String title;
  final String description;
  bool isFavorite;

  RecipeItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    this.isFavorite = false,
  });
}