import 'package:flutter_test/flutter_test.dart';
import 'package:unit_testing/app/features/recipes/data/models/recipe_model.dart';
import 'package:unit_testing/app/features/recipes/domain/entities/recipe.dart';

void main() {
  group('RecipeModel', () {
    const tRecipeModel = RecipeModel(
      id: 1,
      name: 'Test Recipe',
      ingredients: ['Ing 1'],
      instructions: ['Step 1'],
      prepTimeMinutes: 10,
      cookTimeMinutes: 20,
      servings: 2,
      difficulty: 'Easy',
      cuisine: 'Italian',
      caloriesPerServing: 200,
      tags: ['Tag'],
      image: 'test.jpg',
      rating: 4.5,
      reviewCount: 10,
      mealType: ['Lunch'],
      isBookmarked: false,
    );

    test('should be a subclass of Recipe entity', () {
      expect(tRecipeModel, isA<Recipe>());
    });

    test('fromJson should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'name': 'Test Recipe',
        'ingredients': ['Ing 1'],
        'instructions': ['Step 1'],
        'prepTimeMinutes': 10,
        'cookTimeMinutes': 20,
        'servings': 2,
        'difficulty': 'Easy',
        'cuisine': 'Italian',
        'caloriesPerServing': 200,
        'tags': ['Tag'],
        'image': 'test.jpg',
        'rating': 4.5,
        'reviewCount': 10,
        'mealType': ['Lunch'],
        'isBookmarked': false,
      };

      final result = RecipeModel.fromJson(jsonMap);
      expect(result, equals(tRecipeModel));
    });

    test('toJson should return a JSON map containing correct data', () {
      final result = tRecipeModel.toJson();
      final expectedMap = {
        'id': 1,
        'name': 'Test Recipe',
        'ingredients': ['Ing 1'],
        'instructions': ['Step 1'],
        'prepTimeMinutes': 10,
        'cookTimeMinutes': 20,
        'servings': 2,
        'difficulty': 'Easy',
        'cuisine': 'Italian',
        'caloriesPerServing': 200,
        'tags': ['Tag'],
        'image': 'test.jpg',
        'rating': 4.5,
        'reviewCount': 10,
        'mealType': ['Lunch'],
        'isBookmarked': false,
      };
      expect(result, equals(expectedMap));
    });
  });
}
