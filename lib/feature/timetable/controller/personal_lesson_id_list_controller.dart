import 'dart:convert';

import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/timetable/controller/week_period_all_records_controller.dart';
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
    if (!ref.mounted) {
      return;
    }
    final newState = await AsyncValue.guard(() async {
      final current = state.value ?? await _get();
      final next = transform(current);
      await _save(next);
      return next;
    });
    // 非同期処理後に再度mountedチェックしてからstateを設定
    if (!ref.mounted) {
      return;
    }
    state = newState;
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

  /// 指定された科目が重複選択されているかチェック
  ///
  /// 重複が検出された場合、超過分を自動的に削除し、trueを返す。
  /// 重複がない場合はfalseを返す。
  Future<bool> isOverSelected(int lessonId) async {
    final weekPeriodAllRecords =
        await ref.read(weekPeriodAllRecordsProvider.future);
    final personalLessonIdList = state.value ?? await _get();

    final filterWeekPeriod = weekPeriodAllRecords
        .where((element) => element['lessonId'] == lessonId)
        .toList();
    final targetWeekPeriod = filterWeekPeriod
        .where((element) => element['開講時期'] != 0)
        .toList();

    // 開講時期が0（通年）の場合は前期・後期両方に展開
    for (final element
        in filterWeekPeriod.where((element) => element['開講時期'] == 0)) {
      final e1 = <String, dynamic>{...element};
      final e2 = <String, dynamic>{...element};
      e1['開講時期'] = 10;
      e2['開講時期'] = 20;
      targetWeekPeriod.addAll([e1, e2]);
    }

    final removeLessonIdList = <int>{};
    var flag = false;

    for (final record in targetWeekPeriod) {
      final term = record['開講時期'] as int;
      final week = record['week'] as int;
      final period = record['period'] as int;

      final selectedLessonList = weekPeriodAllRecords.where((record) {
        return record['week'] == week &&
            record['period'] == period &&
            (record['開講時期'] == term || record['開講時期'] == 0) &&
            personalLessonIdList.contains(record['lessonId']);
      }).toList();

      if (selectedLessonList.length > 1) {
        final removeLessonList = selectedLessonList.sublist(
          2,
          selectedLessonList.length,
        );
        if (removeLessonList.isNotEmpty) {
          removeLessonIdList.addAll(
            removeLessonList.map((e) => e['lessonId'] as int).toSet(),
          );
        }
        flag = true;
      }
    }

    if (removeLessonIdList.isNotEmpty) {
      final updatedList = personalLessonIdList
          .where((id) => !removeLessonIdList.contains(id))
          .toList();
      await set(updatedList);
    }

    return flag;
  }
}
