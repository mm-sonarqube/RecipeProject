import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/auth/domain/entities/user.dart';
import 'package:unit_testing/app/features/auth/domain/usecases/get_current_user.dart';
import 'package:unit_testing/app/features/auth/domain/usecases/login.dart';
import 'package:unit_testing/app/features/auth/domain/usecases/logout.dart';
import 'package:unit_testing/app/features/auth/domain/usecases/update_profile_photo.dart';
import 'package:unit_testing/app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:unit_testing/app/features/auth/presentation/cubit/auth_state.dart';

class MockLogin extends Mock implements Login {}
class MockLogout extends Mock implements Logout {}
class MockGetCurrentUser extends Mock implements GetCurrentUser {}
class MockUpdateProfilePhoto extends Mock implements UpdateProfilePhoto {}

void main() {
  late AuthCubit cubit;
  late MockLogin mockLogin;
  late MockLogout mockLogout;
  late MockGetCurrentUser mockGetCurrentUser;
  late MockUpdateProfilePhoto mockUpdateProfilePhoto;

  setUp(() {
    mockLogin = MockLogin();
    mockLogout = MockLogout();
    mockGetCurrentUser = MockGetCurrentUser();
    mockUpdateProfilePhoto = MockUpdateProfilePhoto();

    cubit = AuthCubit(
      loginUseCase: mockLogin,
      logoutUseCase: mockLogout,
      getCurrentUserUseCase: mockGetCurrentUser,
      updateProfilePhotoUseCase: mockUpdateProfilePhoto,
    );
  });

  tearDown(() {
    cubit.close();
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

  test('initial state should be AuthInitial', () {
    expect(cubit.state, equals(AuthInitial()));
  });

  group('checkSession', () {
    test('should emit [AuthLoading, Authenticated] when session is found', () async {
      when(() => mockGetCurrentUser()).thenAnswer((_) async => tUser);

      final expectedStates = [
        AuthLoading(),
        const Authenticated(user: tUser),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.checkSession();
    });

    test('should emit [AuthLoading, Unauthenticated] when no session is found', () async {
      when(() => mockGetCurrentUser()).thenAnswer((_) async => null);

      final expectedStates = [
        AuthLoading(),
        Unauthenticated(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.checkSession();
    });
  });

  group('loginUser', () {
    test('should emit [AuthLoading, Authenticated] when login is successful', () async {
      when(() => mockLogin(any(), any())).thenAnswer((_) async => tUser);

      final expectedStates = [
        AuthLoading(),
        const Authenticated(user: tUser),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loginUser('abc.com', '123456');
    });

    test('should emit [AuthLoading, AuthError, Unauthenticated] when login fails', () async {
      when(() => mockLogin(any(), any())).thenThrow(Exception('Invalid credentials'));

      final expectedStates = [
        AuthLoading(),
        const AuthError(message: 'Exception: Invalid credentials'),
        Unauthenticated(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loginUser('wrong@email.com', '123');
    });
  });

  group('logoutUser', () {
    test('should emit [AuthLoading, Unauthenticated] when logout is successful', () async {
      when(() => mockLogout()).thenAnswer((_) async {});

      final expectedStates = [
        AuthLoading(),
        Unauthenticated(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.logoutUser();
    });
  });

  group('updateUserPhoto', () {
    test('should emit [AuthLoading, Authenticated] with updated user details', () async {
      const updatedUser = User(
        id: 1,
        username: 'emilys',
        firstName: 'Emily',
        lastName: 'Johnson',
        email: 'emily.johnson@x.dummyjson.com',
        photoUrl: 'new_pic.jpg',
        accessToken: 'access123',
        refreshToken: 'refresh456',
      );
      when(() => mockUpdateProfilePhoto(any())).thenAnswer((_) async => updatedUser);

      cubit.emit(const Authenticated(user: tUser));

      final expectedStates = [
        AuthLoading(),
        const Authenticated(user: updatedUser),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.updateUserPhoto('new_pic.jpg');
    });
  });
}
