import 'package:flutter_test/flutter_test.dart';
import 'package:unit_testing/app/features/auth/domain/entities/user.dart';

void main() {
  group('User Entity', () {
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

    test('should support value equality', () {
      const user2 = User(
        id: 1,
        username: 'emilys',
        firstName: 'Emily',
        lastName: 'Johnson',
        email: 'emily.johnson@x.dummyjson.com',
        photoUrl: 'https://dummyjson.com/icon/emilys/128',
        accessToken: 'access123',
        refreshToken: 'refresh456',
      );
      expect(tUser, equals(user2));
    });

    test('copyWith should modify photoUrl while preserving other fields', () {
      final updated = tUser.copyWith(photoUrl: 'new_pic.jpg');
      expect(updated.photoUrl, equals('new_pic.jpg'));
      expect(updated.email, equals(tUser.email));
      expect(updated.accessToken, equals(tUser.accessToken));
      expect(updated.firstName, equals(tUser.firstName));
    });
  });
}
