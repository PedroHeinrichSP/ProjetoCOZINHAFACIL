Map<String, Map<String, double>> ingredientConversions = {
  'sugar': {
    'teaspoon to grams': 4.0,
    'spoon to grams': 12.0,
  },
  'flour': {
    'cup to grams': 120.0,
    'ounce to grams': 28.35,
  },
  'butter': {
    'tablespoon to grams': 14.18,
    'cup to grams': 227.0,
  },
  // TODO Add more ingredients and their conversions as needed
};

// TODO refine function
double convertIngredient(String ingredient, double inputValue,
    String sourceUnit, String targetUnit) {
  if (ingredientConversions.containsKey(ingredient) &&
      ingredientConversions[ingredient]
          .containsKey('$sourceUnit to $targetUnit')) {
    double conversionFactor =
        ingredientConversions[ingredient]['$sourceUnit to $targetUnit'];
    return inputValue * conversionFactor;
  } else {
    throw Exception('Conversion not found.');
  }
}
