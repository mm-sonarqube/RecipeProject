import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_local_data_source.dart';
import '../datasources/recipe_remote_data_source.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Recipe>> getRecipes() async {
    final remoteRecipes = await remoteDataSource.getRecipes();
    final bookmarkedIds = await localDataSource.getBookmarkedRecipeIds();

    return remoteRecipes.map((model) {
      final isBookmarked = bookmarkedIds.contains(model.id);
      return model.copyWith(isBookmarked: isBookmarked);
    }).toList();
  }

  @override
  Future<List<int>> getBookmarkedRecipeIds() async {
    return await localDataSource.getBookmarkedRecipeIds();
  }

  @override
  Future<void> toggleBookmark(int recipeId) async {
    final bookmarkedIds = await localDataSource.getBookmarkedRecipeIds();
    final isAlreadyBookmarked = bookmarkedIds.contains(recipeId);
    await localDataSource.cacheBookmark(recipeId, !isAlreadyBookmarked);
  }
}
