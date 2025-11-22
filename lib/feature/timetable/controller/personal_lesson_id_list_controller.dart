import 'dart:convert';

import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'personal_lesson_id_list_controller.g.dart';

@riverpod
final class PersonalLessonIdListNotifier
    extends _$PersonalLessonIdListNotifier {
  @override
  Future<List<int>> build() async {
    return _get();
  }

  Future<List<int>> _get() async {
    final jsonString = await UserPreferenceRepository.getString(
      UserPreferenceKeys.personalTimetableListKey,
    );
    if (jsonString != null) {
      return List<int>.from(json.decode(jsonString) as List);
    }
    return [];
  }

  Future<void> add(int lessonId) async {
    await _updateState((current) => [...current, lessonId]);
  }

  Future<void> remove(int lessonId) async {
    await _updateState(
      (current) => current.where((element) => element != lessonId).toList(),
    );
  }

  Future<void> set(List<int> lessonIdList) async {
    await _updateState((_) => [...lessonIdList]);
  }

  Future<void> _updateState(List<int> Function(List<int>) transform) async {
    state = await AsyncValue.guard(() async {
      final current = state.value ?? await _get();
      final next = transform(current);
      await _save(next);
      return next;
    });
  }

  Future<void> _save(List<int> lessonIdList) async {
    await UserPreferenceRepository.setString(
      UserPreferenceKeys.personalTimetableListKey,
      json.encode(lessonIdList),
    );
    await UserPreferenceRepository.setInt(
      UserPreferenceKeys.personalTimetableLastUpdateKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}
