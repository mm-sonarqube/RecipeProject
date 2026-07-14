import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login(String username, String password) async {
    final userModel = await remoteDataSource.login(username, password);
    await localDataSource.saveSession(userModel);
    return userModel;
  }

  @override
  Future<void> logout() async {
    await localDataSource.deleteSession();
  }

  @override
  Future<User?> getCurrentUser() async {
    return await localDataSource.getSession();
  }

  @override
  Future<User> updateProfilePhoto(String photoUrl) async {
    final currentSession = await localDataSource.getSession();
    if (currentSession == null) {
      throw Exception('No active user session');
    }
    final updatedUser = UserModel(
      id: currentSession.id,
      username: currentSession.username,
      firstName: currentSession.firstName,
      lastName: currentSession.lastName,
      email: currentSession.email,
      photoUrl: photoUrl,
      accessToken: currentSession.accessToken,
      refreshToken: currentSession.refreshToken,
    );
    await localDataSource.saveSession(updatedUser);
    return updatedUser;
  }
}
