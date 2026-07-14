import 'package:flutter_test/flutter_test.dart';
import 'package:unit_testing/app/features/recipes/domain/entities/recipe.dart';

void main() {
  group('Recipe Entity', () {
    const tRecipe = Recipe(
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

    test('should support value equality', () {
      const recipe2 = Recipe(
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
      expect(tRecipe, equals(recipe2));
    });

    test('copyWith should modify fields correctly', () {
      final updated = tRecipe.copyWith(isBookmarked: true);
      expect(updated.isBookmarked, isTrue);
      expect(updated.id, equals(tRecipe.id));
    });
  });
}
