import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:unit_testing/app/features/auth/domain/usecases/logout.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late Logout usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = Logout(mockRepository);
  });

  test('should call logout on auth repository', () async {
    when(() => mockRepository.logout()).thenAnswer((_) async {});

    await usecase();

    verify(() => mockRepository.logout());
    verifyNoMoreInteractions(mockRepository);
  });
}
