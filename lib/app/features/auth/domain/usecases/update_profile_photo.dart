import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateProfilePhoto {
  final AuthRepository repository;

  const UpdateProfilePhoto(this.repository);

  Future<User> call(String photoUrl) async {
    return await repository.updateProfilePhoto(photoUrl);
  }
}
