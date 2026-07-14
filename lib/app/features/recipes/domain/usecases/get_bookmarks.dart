import '../repositories/recipe_repository.dart';

class GetBookmarks {
  final RecipeRepository repository;

  const GetBookmarks(this.repository);

  Future<List<int>> call() async {
    return await repository.getBookmarkedRecipeIds();
  }
}
