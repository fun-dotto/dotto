import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/repository/user_preference_repository.dart';

FutureProvider<String> settingsGradeProvider = FutureProvider((ref) async {
  return await UserPreferenceRepository.getString(UserPreferenceKeys.grade) ??
      'なし';
});
FutureProvider<String> settingsCourseProvider = FutureProvider((ref) async {
  return await UserPreferenceRepository.getString(UserPreferenceKeys.course) ??
      'なし';
});
FutureProvider<String> settingsUserKeyProvider = FutureProvider((ref) async {
  return await UserPreferenceRepository.getString(UserPreferenceKeys.userKey) ??
      '';
});
