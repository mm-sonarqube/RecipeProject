import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/recipes/data/datasources/recipe_remote_data_source.dart';
import 'package:unit_testing/app/features/recipes/data/models/recipe_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late RecipeRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = RecipeRemoteDataSourceImpl(client: mockDio);
  });

  group('getRecipes', () {
    final tRecipeModelList = [
      const RecipeModel(
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

    final tResponseData = {
      'recipes': [
        {
          'id': 1,
          'name': 'Classic Margherita Pizza',
          'ingredients': ['Pizza dough'],
          'instructions': ['Bake'],
          'prepTimeMinutes': 20,
          'cookTimeMinutes': 15,
          'servings': 4,
          'difficulty': 'Easy',
          'cuisine': 'Italian',
          'caloriesPerServing': 300,
          'tags': ['Pizza'],
          'image': 'https://cdn.dummyjson.com/recipe-images/1.webp',
          'rating': 4.6,
          'reviewCount': 98,
          'mealType': ['Dinner'],
        }
      ]
    };

    test('should perform a GET request to the correct URL', () async {
      when(
        () => mockDio.get<dynamic>(
          any(),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await dataSource.getRecipes();

      verify(
        () => mockDio.get<dynamic>(
          'https://dummyjson.com/recipes',
          options: any(named: 'options'),
        ),
      );
    });

    test('should return list of RecipeModels when response is successful', () async {
      when(
        () => mockDio.get<dynamic>(
          any(),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getRecipes();

      expect(result, equals(tRecipeModelList));
    });

    test('should throw Exception when DioException is received', () async {
      when(
        () => mockDio.get<dynamic>(
          any(),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            data: 'Not found',
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(() => dataSource.getRecipes(), throwsException);
    });
  });
}
