import 'dart:convert';

import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/search_course/repository/syllabus_database_config.dart';
import 'package:dotto/feature/timetable/controller/personal_lesson_id_list_controller.dart';
import 'package:dotto/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/repository/user_preference_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final Provider<Future<void>> saveTimetableProvider = Provider((ref) async {
  final personalLessonIdList = ref.watch(personalLessonIdListNotifierProvider);
  await UserPreferenceRepository.setString(
    UserPreferenceKeys.personalTimetableListKey,
    json.encode(personalLessonIdList),
  );
  await UserPreferenceRepository.setInt(
    UserPreferenceKeys.personalTimetableLastUpdateKey,
    DateTime.now().millisecondsSinceEpoch,
  );
});

final StateProvider<Map<DateTime, Map<int, List<TimeTableCourse>>>?>
twoWeekTimeTableDataProvider = StateProvider((ref) => null);
final StateProvider<DateTime> focusTimeTableDayProvider = StateProvider((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});
final FutureProvider<List<Map<String, dynamic>>> weekPeriodAllRecordsProvider =
    FutureProvider((ref) async {
      final dbPath = await SyllabusDatabaseConfig().getDBPath();
      final database = await openDatabase(dbPath);
      final List<Map<String, dynamic>> records = await database.rawQuery(
        'SELECT * FROM week_period order by lessonId',
      );
      return records;
    });
final StateProvider<int> currentTimetablePageIndexProvider = StateProvider((
  ref,
) {
  final now = DateTime.now();
  if ((now.month >= 9) || (now.month <= 2)) {
    return 1;
  }
  return 0;
});
final StateProvider<PageController> timetablePageControllerProvider =
    StateProvider((ref) {
      final now = DateTime.now();
      if ((now.month >= 9) || (now.month <= 2)) {
        return PageController(initialPage: 1);
      }
      return PageController();
    });
final StateProvider<bool> courseCancellationFilterEnabledProvider =
    StateProvider((ref) => true);
final StateProvider<String> courseCancellationSelectedTypeProvider =
    StateProvider((ref) => 'すべて');
