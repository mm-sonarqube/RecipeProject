import '../repositories/settings_repository.dart';

class SaveAboutYou {
  final SettingsRepository repository;

  const SaveAboutYou(this.repository);

  Future<void> call(String aboutYou) async {
    await repository.saveAboutYou(aboutYou);
  }
}
