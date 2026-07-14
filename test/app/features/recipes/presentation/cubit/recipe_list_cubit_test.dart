import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/recipes/domain/entities/recipe.dart';
import 'package:unit_testing/app/features/recipes/domain/usecases/get_recipes.dart';
import 'package:unit_testing/app/features/recipes/domain/usecases/toggle_bookmark.dart';
import 'package:unit_testing/app/features/recipes/presentation/cubit/recipe_list_cubit.dart';
import 'package:unit_testing/app/features/recipes/presentation/cubit/recipe_list_state.dart';

class MockGetRecipes extends Mock implements GetRecipes {}

class MockToggleBookmark extends Mock implements ToggleBookmark {}

void main() {
  late RecipeListCubit cubit;
  late MockGetRecipes mockGetRecipes;
  late MockToggleBookmark mockToggleBookmark;

  setUp(() {
    mockGetRecipes = MockGetRecipes();
    mockToggleBookmark = MockToggleBookmark();
    cubit = RecipeListCubit(
      getRecipesUseCase: mockGetRecipes,
      toggleBookmarkUseCase: mockToggleBookmark,
    );
  });

  tearDown(() {
    cubit.close();
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
      isBookmarked: false,
    )
  ];

  test('initial state should be RecipeListInitial', () {
    expect(cubit.state, equals(RecipeListInitial()));
  });

  group('fetchRecipes', () {
    test('should emit [RecipeListLoading, RecipeListLoaded] when data is gotten successfully', () async {
      when(() => mockGetRecipes()).thenAnswer((_) async => tRecipesList);

      final expectedStates = [
        RecipeListLoading(),
        RecipeListLoaded(recipes: tRecipesList),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchRecipes();
    });

    test('should emit [RecipeListLoading, RecipeListError] when getting data fails', () async {
      when(() => mockGetRecipes()).thenThrow(Exception('Server error'));

      final expectedStates = [
        RecipeListLoading(),
        const RecipeListError(message: 'Exception: Server error'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchRecipes();
    });
  });

  group('toggleRecipeBookmark', () {
    test('should update bookmarked status in recipes list and emit updated RecipeListLoaded', () async {
      when(() => mockToggleBookmark(any())).thenAnswer((_) async {});

      // Set state to Loaded first
      cubit.emit(RecipeListLoaded(recipes: tRecipesList));

      final expectedState = RecipeListLoaded(recipes: [
        tRecipesList[0].copyWith(isBookmarked: true),
      ]);

      expectLater(cubit.stream, emitsInOrder([expectedState]));

      await cubit.toggleRecipeBookmark(1);
    });
  });
}
