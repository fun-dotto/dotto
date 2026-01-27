import 'dart:convert';

import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/timetable_slot.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/search_course/repository/syllabus_database_config.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final class SelectCourseService {
  SelectCourseService(this.ref);

  final Ref ref;

  Future<List<Map<String, dynamic>>> getAvailableCourses({
    required Semester semester,
    required DayOfWeek dayOfWeek,
    required TimetableSlot period,
  }) async {
    final dbPath = await SyllabusDatabaseConfig().getDBPath();
    final database = await openDatabase(dbPath);
    final List<Map<String, dynamic>> records = await database.rawQuery(
      'SELECT * FROM week_period order by lessonId',
    );
    return records.where((record) {
      return record['week'] == dayOfWeek.number &&
          record['period'] == period.number &&
          (record['開講時期'] == semester.number || record['開講時期'] == 0);
    }).toList();
  }

  Future<List<int>> getPersonalLessonIdList() async {
    final jsonString = await UserPreferenceRepository.getString(
      UserPreferenceKeys.personalTimetableListKey,
    );
    if (jsonString != null) {
      return List<int>.from(json.decode(jsonString) as List);
    }
    return [];
  }

  Future<void> addLesson(int lessonId) async {
    final repository = ref.read(timetableRepositoryProvider);
    await repository.addLesson(lessonId);
  }

  Future<void> removeLesson(int lessonId) async {
    final repository = ref.read(timetableRepositoryProvider);
    await repository.removeLesson(lessonId);
  }

  Future<bool> isOverSelected(int lessonId) async {
    final dbPath = await SyllabusDatabaseConfig().getDBPath();
    final database = await openDatabase(dbPath);
    final List<Map<String, dynamic>> weekPeriodAllRecords =
        await database.rawQuery('SELECT * FROM week_period order by lessonId');
    final personalLessonIdList = await getPersonalLessonIdList();

    final filterWeekPeriod = weekPeriodAllRecords
        .where((element) => element['lessonId'] == lessonId)
        .toList();
    final targetWeekPeriod = filterWeekPeriod
        .where((element) => element['開講時期'] != 0)
        .toList();

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
      await _savePersonalLessonIdList(updatedList);
    }

    return flag;
  }

  Future<void> _savePersonalLessonIdList(List<int> lessonIdList) async {
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
