import 'dart:convert';

import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/helper/user_preference_repository.dart';

final class TimetablePreference {
  /// 個人の時間割リスト（lessonIdのリスト）を取得
  static Future<List<int>> getPersonalTimetableList() async {
    final jsonString = await UserPreferenceRepository.getString(
      UserPreferenceKeys.personalTimetableListKey,
    );
    if (jsonString != null) {
      return List<int>.from(json.decode(jsonString) as List);
    }
    return [];
  }
}
