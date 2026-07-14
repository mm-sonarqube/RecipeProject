import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/recipes/data/datasources/recipe_local_data_source.dart';
import 'package:unit_testing/app/features/recipes/data/datasources/recipe_remote_data_source.dart';
import 'package:unit_testing/app/features/recipes/data/models/recipe_model.dart';
import 'package:unit_testing/app/features/recipes/data/repositories/recipe_repository_impl.dart';

class MockRecipeRemoteDataSource extends Mock implements RecipeRemoteDataSource {}

class MockRecipeLocalDataSource extends Mock implements RecipeLocalDataSource {}

void main() {
  late RecipeRepositoryImpl repository;
  late MockRecipeRemoteDataSource mockRemoteDataSource;
  late MockRecipeLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockRecipeRemoteDataSource();
    mockLocalDataSource = MockRecipeLocalDataSource();
    repository = RecipeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('getRecipes', () {
    final tRecipeModels = [
      const RecipeModel(
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
      ),
      const RecipeModel(
        id: 2,
        name: 'Recipe 2',
        ingredients: [],
        instructions: [],
        prepTimeMinutes: 5,
        cookTimeMinutes: 5,
        servings: 1,
        difficulty: 'Easy',
        cuisine: 'American',
        caloriesPerServing: 100,
        tags: [],
        image: 'img2.jpg',
        rating: 4.0,
        reviewCount: 5,
        mealType: [],
      ),
    ];

    test('should return recipes with correct bookmark statuses populated from local datasource', () async {
      when(() => mockRemoteDataSource.getRecipes()).thenAnswer((_) async => tRecipeModels);
      when(() => mockLocalDataSource.getBookmarkedRecipeIds()).thenAnswer((_) async => [1]);

      final result = await repository.getRecipes();

      expect(result.length, equals(2));
      expect(result[0].isBookmarked, isTrue);
      expect(result[1].isBookmarked, isFalse);

      verify(() => mockRemoteDataSource.getRecipes());
      verify(() => mockLocalDataSource.getBookmarkedRecipeIds());
    });
  });

  group('toggleBookmark', () {
    test('should add recipe to bookmarks if it is not already bookmarked', () async {
      when(() => mockLocalDataSource.getBookmarkedRecipeIds()).thenAnswer((_) async => [2]);
      when(() => mockLocalDataSource.cacheBookmark(any(), any())).thenAnswer((_) async {});

      await repository.toggleBookmark(1);

      verify(() => mockLocalDataSource.cacheBookmark(1, true));
    });

    test('should remove recipe from bookmarks if it is already bookmarked', () async {
      when(() => mockLocalDataSource.getBookmarkedRecipeIds()).thenAnswer((_) async => [1, 2]);
      when(() => mockLocalDataSource.cacheBookmark(any(), any())).thenAnswer((_) async {});

      await repository.toggleBookmark(1);

      verify(() => mockLocalDataSource.cacheBookmark(1, false));
    });
  });
}
