import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/recipes/domain/entities/recipe.dart';
import 'package:unit_testing/app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:unit_testing/app/features/recipes/domain/usecases/get_recipes.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}

void main() {
  late GetRecipes usecase;
  late MockRecipeRepository mockRepository;

  setUp(() {
    mockRepository = MockRecipeRepository();
    usecase = GetRecipes(mockRepository);
  });

  final tRecipesList = [
    const Recipe(
      id: 1,
      name: 'Recipe 1',
      ingredients: [],
      instructions: [],
      prepTimeMinutes: 5,
      cookTimeMinutes: 5,
      servings: 1,
      difficulty: 'Easy',
      cuisine: 'American',
      caloriesPerServing: 100,
      tags: [],
      image: 'img1.jpg',
      rating: 4.0,
      reviewCount: 5,
      mealType: [],
    )
  ];

  test('should get recipes from repository', () async {
    when(() => mockRepository.getRecipes()).thenAnswer((_) async => tRecipesList);

    final result = await usecase();

    expect(result, equals(tRecipesList));
    verify(() => mockRepository.getRecipes());
    verifyNoMoreInteractions(mockRepository);
  });
}
