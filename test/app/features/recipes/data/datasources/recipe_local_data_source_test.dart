import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unit_testing/app/features/recipes/data/datasources/recipe_local_data_source.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late RecipeLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = RecipeLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('RecipeLocalDataSource', () {
    const String bookmarkKey = 'CACHED_BOOKMARKS';

    test('should return list of IDs when bookmarks are stored in SharedPreferences', () async {
      when(() => mockSharedPreferences.getStringList(bookmarkKey)).thenReturn(['1', '2']);

      final result = await dataSource.getBookmarkedRecipeIds();

      expect(result, equals([1, 2]));
      verify(() => mockSharedPreferences.getStringList(bookmarkKey));
    });

    test('should return empty list when there are no bookmarks in SharedPreferences', () async {
      when(() => mockSharedPreferences.getStringList(bookmarkKey)).thenReturn(null);

      final result = await dataSource.getBookmarkedRecipeIds();

      expect(result, equals([]));
      verify(() => mockSharedPreferences.getStringList(bookmarkKey));
    });

    test('should cache bookmark correctly when adding a new recipe ID', () async {
      when(() => mockSharedPreferences.getStringList(bookmarkKey)).thenReturn(['1']);
      when(() => mockSharedPreferences.setStringList(any(), any())).thenAnswer((_) async => true);

      await dataSource.cacheBookmark(2, true);

      verify(() => mockSharedPreferences.setStringList(bookmarkKey, ['1', '2']));
    });

    test('should remove bookmark correctly when unbookmarking', () async {
      when(() => mockSharedPreferences.getStringList(bookmarkKey)).thenReturn(['1', '2']);
      when(() => mockSharedPreferences.setStringList(any(), any())).thenAnswer((_) async => true);

      await dataSource.cacheBookmark(1, false);

      verify(() => mockSharedPreferences.setStringList(bookmarkKey, ['2']));
    });
  });
}
