import 'dart:convert';

import 'package:dotto/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/repository/db_config.dart';
import 'package:dotto/repository/setting_user_info.dart';
import 'package:sqflite/sqflite.dart';

final personalLessonIdListProvider =
    NotifierProvider<PersonalLessonIdListNotifier, List<int>>(
        PersonalLessonIdListNotifier.new);

final class PersonalLessonIdListNotifier extends Notifier<List<int>> {
  @override
  List<int> build() {
    return [];
  }

  void add(int lessonId) {
    state = [...state, lessonId];
  }

  void remove(int lessonId) {
    state = state.where((element) => element != lessonId).toList();
  }

  void set(List<int> lessonIdList) {
    state = [...lessonIdList];
  }
}

final Provider<Future<Null>> saveTimetableProvider = Provider((ref) async {
  final personalLessonIdList = ref.watch(personalLessonIdListProvider);
  await UserPreferences.setString(UserPreferenceKeys.personalTimetableListKey,
      json.encode(personalLessonIdList));
  await UserPreferences.setInt(
      UserPreferenceKeys.personalTimetableLastUpdateKey,
      DateTime.now().millisecondsSinceEpoch);
});

final StateProvider<Map<DateTime, Map<int, List<TimeTableCourse>>>?>
    twoWeekTimeTableDataProvider = StateProvider((ref) => null);
final StateProvider<DateTime> focusTimeTableDayProvider = StateProvider((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});
final FutureProvider<List<Map<String, dynamic>>> weekPeriodAllRecordsProvider =
    FutureProvider(
  (ref) async {
    final database = await openDatabase(SyllabusDBConfig.dbPath);
    final List<Map<String, dynamic>> records =
        await database.rawQuery('SELECT * FROM week_period order by lessonId');
    return records;
  },
);
final StateProvider<int> currentTimetablePageIndexProvider =
    StateProvider((ref) {
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
