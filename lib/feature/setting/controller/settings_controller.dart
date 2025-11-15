import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
