import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetRecipes {
  final RecipeRepository repository;

  const GetRecipes(this.repository);

  Future<List<Recipe>> call() async {
    return await repository.getRecipes();
  }
}
