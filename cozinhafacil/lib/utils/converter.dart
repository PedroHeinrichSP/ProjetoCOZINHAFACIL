Map<String, Map<String, double>> ingredientConversions = { // map ingredient to measure to grams
  'sugar': {
    'teaSpoon': 4.0,
    'dessertSpoon': 8.0,
    'commonSpoon': 12.0,
    'cup': 148.0,
    'teaCup': 180.0,
  },
  'starch': {
    'teaSpoon': 3.0,
    'dessertSpoon': 6.0,
    'commonSpoon': 8.0,
    'cup': 105.0,
    'teaCup': 128.0,
  },
  'rice': {
    'teaSpoon': 4.0,
    'dessertSpoon': 8.0,
    'commonSpoon': 12.0,
    'cup': 150.0,
    'teaCup': 185.0,
  },
  'yeast': { //equivalent to sodium bicarbonate and both types of yeast
    'teaSpoon': 5.0,
    'dessertSpoon': 10.0,
    'commonSpoon': 14.0,
    'cup': 184.0,
    'teaCup': 224.0,
  },
  'coffee': {
    'teaSpoon': 2.0,
    'dessertSpoon': 4.0,
    'commonSpoon': 5.0,
    'cup': 66.0,
    'teaCup': 80.0,
  },
  'nuts': {
    'teaSpoon': 3.0,
    'dessertSpoon': 6.0,
    'commonSpoon': 9.0,
    'cup': 115.0,
    'teaCup': 140.0,
  },
  'chocolate': {
    'teaSpoon': 2.0,
    'dessertSpoon': 4.0,
    'commonSpoon': 6.0,
    'cup': 74.0,
    'teaCup': 90.0,
  },
  'coconut': {
    'teaSpoon': 2.0,
    'dessertSpoon': 4.0,
    'commonSpoon': 6.0,
    'cup': 82.0,
    'teaCup': 100.0,
  },
  'wheat': {
    'teaSpoon': 2.5,
    'dessertSpoon': 5.0,
    'commonSpoon': 7.5,
    'cup': 98.5,
    'teaCup': 120.0,
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
