import 'package:cozinhafacil/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'receitas_api.dart';
import 'home.dart';

class FavoritasScreen extends StatelessWidget {
  final List<CardData> allCards;
  final Function(int) toggleFavorite;

  FavoritasScreen(this.allCards, {required this.toggleFavorite});

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = allCards.where((card) => card.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
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