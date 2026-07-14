import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:unit_testing/app/features/recipes/domain/usecases/get_bookmarks.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}

void main() {
  late GetBookmarks usecase;
  late MockRecipeRepository mockRepository;

  setUp(() {
    mockRepository = MockRecipeRepository();
    usecase = GetBookmarks(mockRepository);
  });

  test('should get bookmarked recipe IDs from repository', () async {
    when(() => mockRepository.getBookmarkedRecipeIds()).thenAnswer((_) async => [1, 2]);

    final result = await usecase();

    expect(result, equals([1, 2]));
    verify(() => mockRepository.getBookmarkedRecipeIds());
    verifyNoMoreInteractions(mockRepository);
  });
}
