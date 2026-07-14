import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:unit_testing/app/features/recipes/domain/usecases/toggle_bookmark.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}

void main() {
  late ToggleBookmark usecase;
  late MockRecipeRepository mockRepository;

  setUp(() {
    mockRepository = MockRecipeRepository();
    usecase = ToggleBookmark(mockRepository);
  });

  test('should toggle bookmark in repository', () async {
    when(() => mockRepository.toggleBookmark(any())).thenAnswer((_) async {});

    await usecase(1);

    verify(() => mockRepository.toggleBookmark(1));
    verifyNoMoreInteractions(mockRepository);
  });
}
