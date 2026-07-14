import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_recipes.dart';
import '../../domain/usecases/toggle_bookmark.dart';
import 'recipe_list_state.dart';

class RecipeListCubit extends Cubit<RecipeListState> {
  final GetRecipes getRecipesUseCase;
  final ToggleBookmark toggleBookmarkUseCase;

  RecipeListCubit({
    required this.getRecipesUseCase,
    required this.toggleBookmarkUseCase,
  }) : super(RecipeListInitial());

  Future<void> fetchRecipes() async {
    emit(RecipeListLoading());
    try {
      final recipes = await getRecipesUseCase();
      emit(RecipeListLoaded(recipes: recipes));
    } catch (e) {
      emit(RecipeListError(message: e.toString()));
    }
  }

  Future<void> toggleRecipeBookmark(int id) async {
    final currentState = state;
    if (currentState is RecipeListLoaded) {
      try {
        await toggleBookmarkUseCase(id);
        // Map the current recipes list, toggling bookmark status for the toggled ID
        final updatedRecipes = currentState.recipes.map((recipe) {
          if (recipe.id == id) {
            return recipe.copyWith(isBookmarked: !recipe.isBookmarked);
          }
          return recipe;
        }).toList();
        emit(RecipeListLoaded(recipes: updatedRecipes));
      } catch (e) {
        emit(RecipeListError(message: e.toString()));
      }
    }
  }
}
