import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  const Login(this.repository);

  Future<User> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
