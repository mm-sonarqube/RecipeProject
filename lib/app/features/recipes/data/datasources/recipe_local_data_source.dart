import 'package:shared_preferences/shared_preferences.dart';

abstract class RecipeLocalDataSource {
  Future<List<int>> getBookmarkedRecipeIds();
  Future<void> cacheBookmark(int id, bool isBookmarked);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _bookmarkKey = 'CACHED_BOOKMARKS';

  RecipeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<int>> getBookmarkedRecipeIds() async {
    final list = sharedPreferences.getStringList(_bookmarkKey);
    if (list != null) {
      return list.map((id) => int.parse(id)).toList();
    }
    return [];
  }

  @override
  Future<void> cacheBookmark(int id, bool isBookmarked) async {
    final currentIds = await getBookmarkedRecipeIds();
    if (isBookmarked) {
      if (!currentIds.contains(id)) {
        currentIds.add(id);
      }
    } else {
      currentIds.remove(id);
    }
    final stringList = currentIds.map((e) => e.toString()).toList();
    await sharedPreferences.setStringList(_bookmarkKey, stringList);
  }
}
