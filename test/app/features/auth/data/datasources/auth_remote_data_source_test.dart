import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:unit_testing/app/features/auth/data/models/user_model.dart';

// Mocktail requires mocking the HttpClientAdapter, not Dio itself.
// We mock Dio's adapter so we can control response data directly.
class MockDio extends Mock implements Dio {}

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthRemoteDataSourceImpl(dio: mockDio);
  });

  const tUsername = 'emilys';
  const tPassword = 'emilyspass';

  const tUserModel = UserModel(
    id: 1,
    username: 'emilys',
    firstName: 'Emily',
    lastName: 'Johnson',
    email: 'emily.johnson@x.dummyjson.com',
    photoUrl: 'https://dummyjson.com/icon/emilys/128',
    accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
    refreshToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9refresh',
  );

  final tResponseData = {
    'id': 1,
    'username': 'emilys',
    'firstName': 'Emily',
    'lastName': 'Johnson',
    'email': 'emily.johnson@x.dummyjson.com',
    'image': 'https://dummyjson.com/icon/emilys/128',
    'accessToken': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
    'refreshToken': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9refresh',
  };

  group('AuthRemoteDataSource - login', () {
    test('should return UserModel when POST call succeeds (200)', () async {
      when(
        () => mockDio.post<dynamic>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.login(tUsername, tPassword);

      expect(result, equals(tUserModel));
      verify(
        () => mockDio.post<dynamic>(
          'https://dummyjson.com/auth/login',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      );
    });

    test('should throw Exception when DioException is received (401)', () async {
      when(
        () => mockDio.post<dynamic>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            data: {'message': 'Invalid credentials'},
            statusCode: 401,
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => dataSource.login('wrong', 'creds'),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw Exception on network error (no response)', () async {
      when(
        () => mockDio.post<dynamic>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
          message: 'Connection refused',
        ),
      );

      expect(
        () => dataSource.login(tUsername, tPassword),
        throwsA(isA<Exception>()),
      );
    });
  });
}
