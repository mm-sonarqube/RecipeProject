import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/auth/domain/entities/user.dart';
import 'package:unit_testing/app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:unit_testing/app/features/auth/presentation/cubit/auth_state.dart';
import 'package:unit_testing/app/features/recipes/domain/entities/recipe.dart';
import 'package:unit_testing/app/features/recipes/presentation/cubit/recipe_list_cubit.dart';
import 'package:unit_testing/app/features/recipes/presentation/cubit/recipe_list_state.dart';
import 'package:unit_testing/app/features/recipes/presentation/pages/recipe_list_page.dart';

class MockRecipeListCubit extends Mock implements RecipeListCubit {}
class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockRecipeListCubit mockCubit;
  late MockAuthCubit mockAuthCubit;
  const tUser = User(
    id: 1,
    username: 'emilys',
    firstName: 'Emily',
    lastName: 'Johnson',
    email: 'emily.johnson@x.dummyjson.com',
    photoUrl: '',
    accessToken: 'access123',
    refreshToken: 'refresh456',
  );

  setUp(() {
    mockCubit = MockRecipeListCubit();
    mockAuthCubit = MockAuthCubit();
    when(() => mockCubit.close()).thenAnswer((_) async {});
    when(() => mockAuthCubit.close()).thenAnswer((_) async {});
    // Stub AuthCubit state for recipe list page actions
    when(() => mockAuthCubit.state).thenReturn(const Authenticated(user: tUser));
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const Authenticated(user: tUser)));
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<RecipeListCubit>.value(value: mockCubit),
          BlocProvider<AuthCubit>.value(value: mockAuthCubit),
        ],
        child: const RecipeListPage(),
      ),
    );
  }

  testWidgets('should render Loading indicator when state is RecipeListLoading', (tester) async {
    when(() => mockCubit.state).thenReturn(RecipeListLoading());
    when(() => mockCubit.stream).thenAnswer((_) => Stream.value(RecipeListLoading()));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should render Recipe cards when state is RecipeListLoaded', (tester) async {
    final tRecipes = [
      const Recipe(
        id: 1,
        name: 'Classic Margherita Pizza',
        ingredients: ['Pizza dough'],
        instructions: ['Bake'],
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
      )
    ];

    when(() => mockCubit.state).thenReturn(RecipeListLoaded(recipes: tRecipes));
    when(() => mockCubit.stream).thenAnswer((_) => Stream.value(RecipeListLoaded(recipes: tRecipes)));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Classic Margherita Pizza'), findsOneWidget);
    expect(find.text('Italian'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);
  });

  testWidgets('should render Error message and try again button when state is RecipeListError', (tester) async {
    when(() => mockCubit.state).thenReturn(const RecipeListError(message: 'Error fetching recipes'));
    when(() => mockCubit.stream).thenAnswer((_) => Stream.value(const RecipeListError(message: 'Error fetching recipes')));
    when(() => mockCubit.fetchRecipes()).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Error fetching recipes'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });
}
