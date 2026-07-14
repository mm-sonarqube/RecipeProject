import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/recipes/domain/entities/recipe.dart';
import 'package:unit_testing/app/features/recipes/presentation/cubit/recipe_list_cubit.dart';
import 'package:unit_testing/app/features/recipes/presentation/cubit/recipe_list_state.dart';
import 'package:unit_testing/app/features/recipes/presentation/pages/recipe_detail_page.dart';

class MockRecipeListCubit extends Mock implements RecipeListCubit {}

void main() {
  late MockRecipeListCubit mockCubit;
  const tRecipe = Recipe(
    id: 1,
    name: 'Classic Margherita Pizza',
    ingredients: ['Pizza dough', 'Mozzarella'],
    instructions: ['Bake at 450F'],
    prepTimeMinutes: 20,
    cookTimeMinutes: 15,
    servings: 4,
    difficulty: 'Easy',
    cuisine: 'Italian',
    caloriesPerServing: 300,
    tags: ['Pizza'],
    image: 'https://cdn.dummyjson.com/recipe-images/1.webp',
    rating: 4.6,
    reviewCount: 98,
    mealType: ['Dinner'],
    isBookmarked: false,
  );

  setUp(() {
    mockCubit = MockRecipeListCubit();
    when(() => mockCubit.close()).thenAnswer((_) async {});
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<RecipeListCubit>.value(
        value: mockCubit,
        child: const RecipeDetailPage(recipe: tRecipe),
      ),
    );
  }

  testWidgets('should render recipe detailed elements correctly', (tester) async {
    when(() => mockCubit.state).thenReturn(RecipeListInitial());
    when(() => mockCubit.stream).thenAnswer((_) => Stream.value(RecipeListInitial()));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Classic Margherita Pizza'), findsOneWidget);
    expect(find.text('Italian'), findsOneWidget);
    expect(find.text('Pizza dough'), findsOneWidget);
    expect(find.text('Mozzarella'), findsOneWidget);
    expect(find.text('Bake at 450F'), findsOneWidget);
    expect(find.text('20 mins'), findsOneWidget);
    expect(find.text('300 kcal'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('should call toggleRecipeBookmark on cubit when bookmark button clicked', (tester) async {
    when(() => mockCubit.state).thenReturn(RecipeListInitial());
    when(() => mockCubit.stream).thenAnswer((_) => Stream.value(RecipeListInitial()));
    when(() => mockCubit.toggleRecipeBookmark(any())).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestableWidget());

    // Find the bookmark button in the app bar actions
    final bookmarkButton = find.byIcon(Icons.bookmark_border);
    expect(bookmarkButton, findsOneWidget);

    await tester.tap(bookmarkButton);
    await tester.pump();

    verify(() => mockCubit.toggleRecipeBookmark(1)).called(1);
  });
}
