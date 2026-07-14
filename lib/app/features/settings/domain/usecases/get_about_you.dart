import '../repositories/settings_repository.dart';

class GetAboutYou {
  final SettingsRepository repository;

  const GetAboutYou(this.repository);

  Future<String> call() async {
    return await repository.getAboutYou();
  }
}
