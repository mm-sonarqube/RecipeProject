import 'package:dio/dio.dart';
import '../models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getRecipes();
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio client;

  RecipeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RecipeModel>> getRecipes() async {
    try {
      final response = await client.get(
        'https://dummyjson.com/recipes',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final List recipesJson = response.data['recipes'] as List;
      return recipesJson
          .map((json) => RecipeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Server error: ${e.response?.statusCode ?? 'unknown'}');
    }
  }
}
