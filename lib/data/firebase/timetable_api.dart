import 'dart:convert';

import 'package:dotto/data/db/course_db.dart';
import 'package:dotto/data/firebase/model/timetable_course_response.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/search_course/repository/syllabus_database_config.dart';
import 'package:dotto/helper/read_json_file.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:sqflite/sqflite.dart';

final class TimetableAPI {
  /// 月曜から次の週の日曜までの日付を返す
  static List<DateTime> _getDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // 月曜
    final startDate = today.subtract(Duration(days: today.weekday - 1));

    final dates = <DateTime>[];
    for (var i = 0; i < 14; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }

    return dates;
  }

  // 施設予約のjsonファイルの中から取得している科目のみに絞り込み
  static Future<List<dynamic>> _filterTimetable() async {
    const fileName = 'map/oneweek_schedule.json';
    try {
      final jsonString = await readJsonFile(fileName);
      final jsonData = json.decode(jsonString) as List<dynamic>;
      final personalTimetableList = await _getPersonalTimetableList();
      final filteredData = <dynamic>[];
      for (final lessonId in personalTimetableList) {
        for (final item in jsonData) {
          final itemMap = item as Map<String, dynamic>;
          if (itemMap['lessonId'] == lessonId.toString()) {
            filteredData.add(item);
          }
        }
      }
      return filteredData;
    } on Exception {
      return [];
    }
  }

  static Future<List<int>> _getPersonalTimetableList() async {
    final jsonString = await UserPreferenceRepository.getString(
      UserPreferenceKeys.personalTimetableListKey,
    );
    if (jsonString != null) {
      return List<int>.from(json.decode(jsonString) as List);
    }
    return [];
  }

  static Future<Map<String, int>> _loadPersonalTimetableMapString() async {
    final personalTimetableList = await _getPersonalTimetableList();
    final dbPath = await SyllabusDatabaseConfig().getDBPath();
    final database = await openDatabase(dbPath);
    final loadPersonalTimetableMap = <String, int>{};
    final List<Map<String, dynamic>> records = await database.rawQuery(
      'select LessonId, 授業名 from sort where LessonId in '
      '(${personalTimetableList.join(",")})',
    );
    for (final record in records) {
      final lessonName = record['授業名'] as String;
      final lessonId = record['LessonId'] as int;
      loadPersonalTimetableMap[lessonName] = lessonId;
    }
    return loadPersonalTimetableMap;
  }

  // 時間を入れたらその日の授業を返す
  static Future<Map<int, List<TimetableCourseResponse>>> _dailyLessonSchedule(
    DateTime selectTime,
  ) async {
    final periodData = <int, Map<int, TimetableCourseResponse>>{
      1: {},
      2: {},
      3: {},
      4: {},
      5: {},
      6: {},
    };
    final returnData = <int, List<TimetableCourseResponse>>{};

    final lessonData = await _filterTimetable();

    for (final item in lessonData) {
      final itemMap = item as Map<String, dynamic>;
      final lessonTime = DateTime.parse(itemMap['start'] as String);

      if (selectTime.day == lessonTime.day) {
        final period = itemMap['period'] as int;
        final lessonId = int.parse(itemMap['lessonId'] as String);
        final resourceId = <int>[];
        try {
          resourceId.add(int.parse(itemMap['resourceId'] as String));
        } on FormatException {
          // resourceIdが空白
        }
        if (periodData.containsKey(period)) {
          if (periodData[period]!.containsKey(lessonId)) {
            periodData[period]![lessonId]!.resourseIds.addAll(resourceId);
            continue;
          }
        }
        final courseData = await CourseDB.fetchDB(lessonId);
        periodData[period]![lessonId] = TimetableCourseResponse(
          lessonId: lessonId,
          title: itemMap['title'] as String,
          kakomonLessonId: courseData?['過去問'] as int?,
          resourseIds: resourceId,
        );
      }
    }

    var jsonData = await readJsonFile('home/cancel_lecture.json');
    final cancelLectureData = jsonDecode(jsonData) as List<dynamic>;
    jsonData = await readJsonFile('home/sup_lecture.json');
    final supLectureData = jsonDecode(jsonData) as List<dynamic>;
    final loadPersonalTimetableMap = await _loadPersonalTimetableMapString();

    for (final cancelLecture in cancelLectureData) {
      final cancelMap = cancelLecture as Map<String, dynamic>;
      final dt = DateTime.parse(cancelMap['date'] as String);
      if (dt.month == selectTime.month && dt.day == selectTime.day) {
        final lessonName = cancelMap['lessonName'] as String;
        if (loadPersonalTimetableMap.containsKey(lessonName)) {
          final lessonId = loadPersonalTimetableMap[lessonName]!;
          final courseData = await CourseDB.fetchDB(lessonId);
          periodData[cancelMap['period']
              as int]![lessonId] = TimetableCourseResponse(
            lessonId: lessonId,
            title: lessonName,
            kakomonLessonId: courseData?['過去問'] as int?,
            resourseIds: [],
            cancel: true,
          );
        }
      }
    }

    for (final supLecture in supLectureData) {
      final supMap = supLecture as Map<String, dynamic>;
      final dt = DateTime.parse(supMap['date'] as String);
      if (dt.month == selectTime.month && dt.day == selectTime.day) {
        final lessonName = supMap['lessonName'] as String;
        if (loadPersonalTimetableMap.containsKey(lessonName)) {
          final lessonId = loadPersonalTimetableMap[lessonName]!;
          periodData[supMap['period'] as int]![lessonId] =
              periodData[supMap['period'] as int]![lessonId]!.copyWith(
                sup: true,
              );
        }
      }
    }
    periodData.forEach((key, value) {
      returnData[key] = value.values.toList();
    });
    return returnData;
  }

  static Future<Map<DateTime, Map<int, List<TimetableCourseResponse>>>>
  getTimetables() async {
    final dates = _getDateRange();
    final twoWeekLessonSchedule =
        <DateTime, Map<int, List<TimetableCourseResponse>>>{};
    try {
      for (final date in dates) {
        twoWeekLessonSchedule[date] = await _dailyLessonSchedule(date);
      }
      return twoWeekLessonSchedule;
    } on Exception {
      return twoWeekLessonSchedule;
    }
  }
}
