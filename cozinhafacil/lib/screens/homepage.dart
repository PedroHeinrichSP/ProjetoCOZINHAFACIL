import 'package:cozinhafacil/utils/pallete.dart';
import 'package:flutter/material.dart';

import 'package:cozinhafacil/screens/SearchScreen.dart';

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
    ),
    RecipeItem(
      imageUrl: 'https://media-cdn.tripadvisor.com/media/photo-s/19/6a/f1/a4/16-ninesixteenth.jpg',
      title: 'Recipe 2',
      description: 'Description for Recipe 2',
    ),
    RecipeItem(
      imageUrl: 'https://miro.medium.com/v2/resize:fit:1200/1*dx1MHKoqVApb5_KCylBoew.jpeg',
      title: 'Recipe 3',
      description: 'Description for Recipe 3',
    ),
    // Add more items as needed
  ];

  // PageController for controlling the PageView
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              // Handle search button tap
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

class RecipeCard extends StatelessWidget {
  final RecipeItem recipe;

  RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(recipe.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.black.withOpacity(0.7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  recipe.description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
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

  RecipeItem({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

