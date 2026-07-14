import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:unit_testing/app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:unit_testing/app/features/auth/data/models/user_model.dart';
import 'package:unit_testing/app/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  const tUsername = 'emilys';
  const tPassword = 'emilyspass';

  const tUserModel = UserModel(
    id: 1,
    username: 'emilys',
    firstName: 'Emily',
    lastName: 'Johnson',
    email: 'emily.johnson@x.dummyjson.com',
    photoUrl: 'https://dummyjson.com/icon/emilys/128',
    accessToken: 'access123',
    refreshToken: 'refresh456',
  );

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
    registerFallbackValue(tUserModel);
  });

  group('login', () {
    test('should call remote, save session, and return UserModel on success', () async {
      when(() => mockRemoteDataSource.login(tUsername, tPassword))
          .thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.saveSession(any())).thenAnswer((_) async {});

      final result = await repository.login(tUsername, tPassword);

      expect(result, equals(tUserModel));
      verify(() => mockRemoteDataSource.login(tUsername, tPassword));
      verify(() => mockLocalDataSource.saveSession(tUserModel));
    });

    test('should throw Exception when remote login fails', () async {
      when(() => mockRemoteDataSource.login(any(), any()))
          .thenThrow(Exception('Login failed (401): Invalid credentials'));

      expect(
        () => repository.login('wrong', 'creds'),
        throwsException,
      );
      verifyZeroInteractions(mockLocalDataSource);
    });
  });

  group('logout', () {
    test('should call deleteSession on local datasource', () async {
      when(() => mockLocalDataSource.deleteSession()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockLocalDataSource.deleteSession());
    });
  });

  group('getCurrentUser', () {
    test('should return UserModel from local datasource', () async {
      when(() => mockLocalDataSource.getSession()).thenAnswer((_) async => tUserModel);

      final result = await repository.getCurrentUser();

      expect(result, equals(tUserModel));
      verify(() => mockLocalDataSource.getSession());
    });

    test('should return null when no session exists', () async {
      when(() => mockLocalDataSource.getSession()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result, isNull);
    });
  });

  group('updateProfilePhoto', () {
    test('should update photoUrl and persist updated session', () async {
      when(() => mockLocalDataSource.getSession()).thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.saveSession(any())).thenAnswer((_) async {});

      final result = await repository.updateProfilePhoto('new_pic.jpg');

      expect(result.photoUrl, equals('new_pic.jpg'));
      verify(() => mockLocalDataSource.saveSession(
            const UserModel(
              id: 1,
              username: 'emilys',
              firstName: 'Emily',
              lastName: 'Johnson',
              email: 'emily.johnson@x.dummyjson.com',
              photoUrl: 'new_pic.jpg',
              accessToken: 'access123',
              refreshToken: 'refresh456',
            ),
          ));
    });

    test('should throw Exception when no active session is found', () async {
      when(() => mockLocalDataSource.getSession()).thenAnswer((_) async => null);

      expect(() => repository.updateProfilePhoto('new_pic.jpg'), throwsException);
    });
  });
}
