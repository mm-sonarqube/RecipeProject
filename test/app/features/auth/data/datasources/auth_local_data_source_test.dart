import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unit_testing/app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:unit_testing/app/features/auth/data/models/user_model.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AuthLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('AuthLocalDataSource', () {
    const sessionKey = 'USER_SESSION';
    const tUser = UserModel(
      id: 1,
      username: 'emilys',
      firstName: 'Emily',
      lastName: 'Johnson',
      email: 'emily@example.com',
      photoUrl: 'https://dummyjson.com/icon/emilys/128',
      accessToken: 'access123',
      refreshToken: 'refresh456',
    );
    const tJsonStr =
        '{"id":1,"username":"emilys","firstName":"Emily","lastName":"Johnson","email":"emily@example.com","image":"https://dummyjson.com/icon/emilys/128","accessToken":"access123","refreshToken":"refresh456"}';

    test('should return UserModel when session is stored in SharedPreferences', () async {
      when(() => mockSharedPreferences.getString(sessionKey)).thenReturn(tJsonStr);

      final result = await dataSource.getSession();

      expect(result, equals(tUser));
      verify(() => mockSharedPreferences.getString(sessionKey));
    });

    test('should return null when session is not stored in SharedPreferences', () async {
      when(() => mockSharedPreferences.getString(sessionKey)).thenReturn(null);

      final result = await dataSource.getSession();

      expect(result, isNull);
      verify(() => mockSharedPreferences.getString(sessionKey));
    });

    test('should save session in SharedPreferences correctly', () async {
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);

      await dataSource.saveSession(tUser);

      verify(() => mockSharedPreferences.setString(sessionKey, tJsonStr));
    });

    test('should delete session from SharedPreferences correctly', () async {
      when(() => mockSharedPreferences.remove(any())).thenAnswer((_) async => true);

      await dataSource.deleteSession();

      verify(() => mockSharedPreferences.remove(sessionKey));
    });
  });
}
