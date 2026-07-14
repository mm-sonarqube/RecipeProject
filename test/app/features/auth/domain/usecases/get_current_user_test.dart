import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/auth/domain/entities/user.dart';
import 'package:unit_testing/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:unit_testing/app/features/auth/domain/usecases/get_current_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetCurrentUser usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = GetCurrentUser(mockRepository);
  });

  const tUser = User(
    id: 1,
    username: 'emilys',
    firstName: 'Emily',
    lastName: 'Johnson',
    email: 'emily.johnson@x.dummyjson.com',
    photoUrl: 'https://dummyjson.com/icon/emilys/128',
    accessToken: 'access123',
    refreshToken: 'refresh456',
  );

  test('should call getCurrentUser on auth repository', () async {
    when(() => mockRepository.getCurrentUser()).thenAnswer((_) async => tUser);

    final result = await usecase();

    expect(result, equals(tUser));
    verify(() => mockRepository.getCurrentUser());
    verifyNoMoreInteractions(mockRepository);
  });
}
