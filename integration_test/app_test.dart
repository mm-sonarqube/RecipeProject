import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:unit_testing/app/core/constants/app_constants.dart';
import 'package:unit_testing/main.dart' as app;
import 'package:unit_testing/app/features/recipes/presentation/pages/recipe_list_page.dart';
import 'package:unit_testing/app/features/recipes/presentation/pages/recipe_detail_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Integration Test (Patrol Finders)', () {
    testWidgets('Verify complete user journey (Login → Recipes → Bookmark)', (WidgetTester tester) async {
      // Wrap WidgetTester in PatrolTester to get $ finder syntax
      final $ = PatrolTester(
        tester: tester,
        config: const PatrolTesterConfig(),
      );

      // ── Setup ──────────────────────────────────────────────────────────
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      final mockAuthDio = Dio();
      mockAuthDio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.path.endsWith('/auth/login')) {
            return handler.resolve(Response(
              requestOptions: options,
              data: {
                'id': 1,
                'username': 'emilys',
                'firstName': 'Emily',
                'lastName': 'Sens',
                'email': 'emily@example.com',
                'image': '',
                'accessToken': 'mock_access_token',
                'refreshToken': 'mock_refresh_token',
              },
              statusCode: 200,
            ));
          }
          return handler.next(options);
        },
      ));

      final mockRecipeDio = Dio();
      mockRecipeDio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.path.endsWith('/recipes')) {
            return handler.resolve(Response(
              requestOptions: options,
              data: {
                'recipes': [
                  {
                    'id': 1,
                    'name': 'Classic Margherita Pizza',
                    'ingredients': ['Pizza dough', 'Tomato sauce', 'Mozzarella'],
                    'instructions': [
                      'Preheat the oven.',
                      'Roll out the dough.',
                      'Bake the pizza.',
                    ],
                    'prepTimeMinutes': 20,
                    'cookTimeMinutes': 15,
                    'servings': 4,
                    'difficulty': 'Easy',
                    'cuisine': 'Italian',
                    'caloriesPerServing': 300,
                    'tags': ['Pizza', 'Italian'],
                    'image': 'https://cdn.dummyjson.com/recipe-images/1.jpg',
                    'rating': 4.6,
                    'reviewCount': 98,
                    'mealType': ['Dinner'],
                  }
                ],
              },
              statusCode: 200,
            ));
          }
          return handler.next(options);
        },
      ));

      // ── Step 1: Launch App ─────────────────────────────────────────────
      app.main(authDio: mockAuthDio, recipeDio: mockRecipeDio);

      // Pump in short intervals — pumpAndSettle hangs on CircularProgressIndicator
      for (int i = 0; i < 15; i++) {
        await tester.pump(const Duration(milliseconds: 200));
        if ($(AppConstants.welcomeMessage).evaluate().isNotEmpty) break;
      }

      // ── Step 2: Verify Login Page ──────────────────────────────────────
      // Using Patrol $ finder syntax for assertions
      expect($(AppConstants.welcomeMessage), findsOneWidget);
      expect($(TextField).at(0), findsOneWidget); // Username field
      expect($(TextField).at(1), findsOneWidget); // Password field

      // ── Step 3: Enter Credentials using Patrol's enterText ─────────────
      await $(TextField).at(0).enterText('abc.com');
      await $(TextField).at(1).enterText('123456');

      // ── Step 4: Tap Login Button ───────────────────────────────────────
      await $(ElevatedButton).tap();

      // Wait for RecipeListPage to appear
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 300));
        if ($(RecipeListPage).evaluate().isNotEmpty) break;
      }

      // ── Step 5: Verify Recipe List Page ───────────────────────────────
      expect($(RecipeListPage), findsOneWidget);

      // Wait for mock recipe data to load
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 300));
        if ($('Classic Margherita Pizza').evaluate().isNotEmpty) break;
      }
      expect($('Classic Margherita Pizza'), findsOneWidget);

      // ── Step 6: Navigate to Detail Page ───────────────────────────────
      await $('Classic Margherita Pizza').tap();

      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 200));
        if ($(RecipeDetailPage).evaluate().isNotEmpty) break;
      }
      expect($(RecipeDetailPage), findsOneWidget);

      // ── Step 7: Bookmark the Recipe ────────────────────────────────────
      // Use descendant finder to avoid ambiguity with icons in background routes
      await tester.tap(
        find.descendant(
          of: find.byType(RecipeDetailPage),
          matching: find.byIcon(Icons.bookmark_border),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      // Confirm bookmark icon toggled
      expect(
        find.descendant(
          of: find.byType(RecipeDetailPage),
          matching: find.byIcon(Icons.bookmark),
        ),
        findsOneWidget,
      );

      // ── Step 8: Go Back ────────────────────────────────────────────────
      await tester.tap(
        find.descendant(
          of: find.byType(RecipeDetailPage),
          matching: find.byIcon(Icons.arrow_back),
        ),
      );

      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 200));
        if ($(RecipeListPage).evaluate().isNotEmpty) break;
      }

      // ── Step 9: Verify Bookmarks Tab ──────────────────────────────────
      await $('Bookmarks').tap();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.descendant(
          of: find.byType(RecipeListPage),
          matching: find.byIcon(Icons.bookmark),
        ),
        findsAtLeast(1),
      );
    });
  });
}
