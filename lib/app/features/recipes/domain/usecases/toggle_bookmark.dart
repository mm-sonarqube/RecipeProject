import '../repositories/recipe_repository.dart';

class ToggleBookmark {
  final RecipeRepository repository;

  const ToggleBookmark(this.repository);

  Future<void> call(int recipeId) async {
    await repository.toggleBookmark(recipeId);
  }
}
