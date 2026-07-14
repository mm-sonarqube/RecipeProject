import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes();
  Future<List<int>> getBookmarkedRecipeIds();
  Future<void> toggleBookmark(int recipeId);
}
