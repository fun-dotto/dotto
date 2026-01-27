import 'dart:convert';

import 'package:dotto/data/db/course_db.dart';
import 'package:dotto/data/firebase/model/timetable_course_response.dart';
import 'package:dotto/data/firebase/room_api.dart';
import 'package:dotto/domain/timetable.dart';
import 'package:dotto/domain/timetable_course.dart';
import 'package:dotto/domain/timetable_course_type.dart';
import 'package:dotto/domain/timetable_slot.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/helper/read_json_file.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>(
  (_) => TimetableRepositoryImpl(),
);

//
// ignore: one_member_abstracts
abstract class TimetableRepository {
  Future<List<Timetable>> getTimetables();
}

final class TimetableRepositoryImpl implements TimetableRepository {
  @override
  Future<List<Timetable>> getTimetables() async {
    try {
      final response = await TimetableRepositoryImpl._getTimetables();
      final rooms = await RoomAPI.getRooms();

      // 部屋IDから部屋名を取得するマップを作成
      final roomNameMap = <int, String>{};
      for (final floorRooms in rooms.values) {
        for (final entry in floorRooms.entries) {
          final roomId = int.tryParse(entry.key);
          if (roomId != null) {
            roomNameMap[roomId] = entry.value.header;
          }
        }
      }

      return response.entries.map((dateEntry) {
        final date = dateEntry.key;
        final periodMap = dateEntry.value;

        final courses = <TimetableCourse>[];
        for (final periodEntry in periodMap.entries) {
          final period = periodEntry.key;
          final courseResponses = periodEntry.value;

          for (final courseResponse in courseResponses) {
            courses.add(_convertToCourse(courseResponse, period, roomNameMap));
          }
        }

        return Timetable(date: date, courses: courses);
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  TimetableCourse _convertToCourse(
    TimetableCourseResponse response,
    int period,
    Map<int, String> roomNameMap,
  ) {
    // 部屋名を取得（複数ある場合はカンマ区切りで結合）
    final roomNames = response.resourseIds
        .map((id) => roomNameMap[id] ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
    final roomName = roomNames.isNotEmpty ? roomNames.join(', ') : '';

    // 授業タイプを判定
    TimetableCourseType type;
    if (response.cancel) {
      type = TimetableCourseType.cancelled;
    } else if (response.sup) {
      type = TimetableCourseType.madeUp;
    } else {
      type = TimetableCourseType.normal;
    }

    return TimetableCourse(
      lessonId: response.lessonId,
      kakomonLessonId: response.kakomonLessonId,
      slot: TimetableSlot.fromNumber(period),
      courseName: response.title,
      roomName: roomName,
      type: type,
    );
  }

  // TODO: Refactor

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
    final personalTimetableList = await _getPersonalTimetableList();
    final loadPersonalTimetableMap = await CourseDB.getLessonIdMap(
      personalTimetableList,
    );

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
  _getTimetables() async {
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
