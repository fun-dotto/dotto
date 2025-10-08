import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/setting/domain/grade.dart';
import 'package:dotto/repository/user_preference_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FutureProvider<Grade?> settingsGradeProvider = FutureProvider((ref) async {
  final savedLabel =
      await UserPreferenceRepository.getString(UserPreferenceKeys.grade);
  if (savedLabel == null || savedLabel == 'なし') return null;
  return Grade.fromLabel(savedLabel);
});
FutureProvider<String> settingsCourseProvider = FutureProvider((ref) async {
  return await UserPreferenceRepository.getString(UserPreferenceKeys.course) ??
      'なし';
});
FutureProvider<String> settingsUserKeyProvider = FutureProvider((ref) async {
  return await UserPreferenceRepository.getString(UserPreferenceKeys.userKey) ??
      '';
});
