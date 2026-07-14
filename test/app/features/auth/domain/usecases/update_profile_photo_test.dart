import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/auth/domain/entities/user.dart';
import 'package:unit_testing/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:unit_testing/app/features/auth/domain/usecases/update_profile_photo.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UpdateProfilePhoto usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = UpdateProfilePhoto(mockRepository);
  });

  const tUser = User(
    id: 1,
    username: 'emilys',
    firstName: 'Emily',
    lastName: 'Johnson',
    email: 'emily.johnson@x.dummyjson.com',
    photoUrl: 'new_pic.jpg',
    accessToken: 'access123',
    refreshToken: 'refresh456',
  );

  test('should call updateProfilePhoto on auth repository', () async {
    when(() => mockRepository.updateProfilePhoto(any())).thenAnswer((_) async => tUser);

    final result = await usecase('new_pic.jpg');

    expect(result, equals(tUser));
    verify(() => mockRepository.updateProfilePhoto('new_pic.jpg'));
    verifyNoMoreInteractions(mockRepository);
  });
}
