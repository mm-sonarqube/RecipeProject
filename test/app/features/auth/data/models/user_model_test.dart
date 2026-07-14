import 'package:flutter_test/flutter_test.dart';
import 'package:unit_testing/app/features/auth/data/models/user_model.dart';
import 'package:unit_testing/app/features/auth/domain/entities/user.dart';

void main() {
  group('UserModel', () {
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

    test('should be a subclass of User entity', () {
      expect(tUserModel, isA<User>());
    });

    test('fromJson should return a valid model from DummyJSON response', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'username': 'emilys',
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'email': 'emily.johnson@x.dummyjson.com',
        'image': 'https://dummyjson.com/icon/emilys/128',
        'accessToken': 'access123',
        'refreshToken': 'refresh456',
      };
      final result = UserModel.fromJson(jsonMap);
      expect(result, equals(tUserModel));
    });

    test('toJson should return a JSON map with correct keys and values', () {
      final result = tUserModel.toJson();
      expect(result, equals({
        'id': 1,
        'username': 'emilys',
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'email': 'emily.johnson@x.dummyjson.com',
        'image': 'https://dummyjson.com/icon/emilys/128',
        'accessToken': 'access123',
        'refreshToken': 'refresh456',
      }));
    });
  });
}
