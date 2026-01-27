import 'package:dotto/data/db/course_db.dart';
import 'package:dotto/data/firebase/room_api.dart';
import 'package:dotto/data/json/model/one_week_schedule.dart';
import 'package:dotto/data/json/timetable_json.dart';
import 'package:dotto/data/preference/timetable_preference.dart';
import 'package:dotto/domain/timetable.dart';
import 'package:dotto/domain/timetable_course.dart';
import 'package:dotto/domain/timetable_course_type.dart';
import 'package:dotto/domain/timetable_slot.dart';
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

/// 時間割データ構築用の内部クラス
class _CourseData {
  _CourseData({
    required this.lessonId,
    required this.title,
    required this.kakomonLessonId,
    required this.resourceIds,
    this.cancel = false,
    this.sup = false,
  });

  final int lessonId;
  final String title;
  final int? kakomonLessonId;
  final List<int> resourceIds;
  bool cancel;
  bool sup;
}

final class TimetableRepositoryImpl implements TimetableRepository {
  @override
  Future<List<Timetable>> getTimetables() async {
    try {
      final response = await _getTimetables();

      return response.entries.map((dateEntry) {
        final date = dateEntry.key;
        final periodMap = dateEntry.value;

        final courses = <TimetableCourse>[];
        for (final periodEntry in periodMap.entries) {
          courses.addAll(periodEntry.value);
        }

        return Timetable(date: date, courses: courses);
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  /// 月曜から次の週の日曜までの日付を返す
  List<DateTime> _getDateRange() {
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
  Future<List<OneWeekSchedule>> _filterTimetable() async {
    try {
      final jsonData = await TimetableJSON.fetchOneWeekSchedule();
      final personalTimetableList =
          await TimetablePreference.getPersonalTimetableList();
      final filteredData = <OneWeekSchedule>[];
      for (final lessonId in personalTimetableList) {
        for (final item in jsonData) {
          if (item.lessonId == lessonId.toString()) {
            filteredData.add(item);
          }
        }
      }
      return filteredData;
    } on Exception {
      return [];
    }
  }

  // 時間を入れたらその日の授業を返す
  Future<Map<int, List<TimetableCourse>>> _dailyLessonSchedule(
    DateTime selectTime,
  ) async {
    final periodData = _initializePeriodData();

    // 部屋IDから部屋名を取得するマップを作成
    final rooms = await RoomAPI.getRooms();
    final roomNameMap = <int, String>{};
    for (final floorRooms in rooms.values) {
      for (final entry in floorRooms.entries) {
        final roomId = int.tryParse(entry.key);
        if (roomId != null) {
          roomNameMap[roomId] = entry.value.header;
        }
      }
    }

    await _processNormalCourses(selectTime, periodData);

    final personalTimetableList =
        await TimetablePreference.getPersonalTimetableList();
    final lessonIdMap = await CourseDB.getLessonIdMap(personalTimetableList);

    await _processCancelledLectures(selectTime, periodData, lessonIdMap);
    await _processSupplementaryLectures(selectTime, periodData, lessonIdMap);

    return _convertPeriodDataToCourses(periodData, roomNameMap);
  }

  /// 時限ごとのデータマップを初期化
  Map<int, Map<int, _CourseData>> _initializePeriodData() {
    return {
      1: {},
      2: {},
      3: {},
      4: {},
      5: {},
      6: {},
    };
  }

  /// 通常授業の処理
  Future<void> _processNormalCourses(
    DateTime selectTime,
    Map<int, Map<int, _CourseData>> periodData,
  ) async {
    final lessonData = await _filterTimetable();

    for (final item in lessonData) {
      final lessonTime = DateTime.parse(item.start);

      if (selectTime.day == lessonTime.day) {
        final period = item.period;
        final lessonId = int.parse(item.lessonId);
        final resourceIds = _parseResourceId(item.resourceId);

        // 既に同じ授業が登録されている場合は教室情報を追加
        if (periodData[period]?.containsKey(lessonId) ?? false) {
          periodData[period]![lessonId]!.resourceIds.addAll(resourceIds);
          continue;
        }

        final courseData = await CourseDB.fetchDB(lessonId);
        periodData[period]![lessonId] = _CourseData(
          lessonId: lessonId,
          title: item.title,
          kakomonLessonId: courseData?.kakomonLessonId,
          resourceIds: resourceIds,
        );
      }
    }
  }

  /// 休講情報の処理
  Future<void> _processCancelledLectures(
    DateTime selectTime,
    Map<int, Map<int, _CourseData>> periodData,
    Map<String, int> lessonIdMap,
  ) async {
    final cancelLectureData = await TimetableJSON.fetchCancelLectures();

    for (final cancelLecture in cancelLectureData) {
      if (!_isSameDate(cancelLecture.date, selectTime)) {
        continue;
      }

      final lessonName = cancelLecture.lessonName;
      if (!lessonIdMap.containsKey(lessonName)) {
        continue;
      }

      final lessonId = lessonIdMap[lessonName]!;
      final courseData = await CourseDB.fetchDB(lessonId);

      periodData[cancelLecture.period]![lessonId] = _CourseData(
        lessonId: lessonId,
        title: lessonName,
        kakomonLessonId: courseData?.kakomonLessonId,
        resourceIds: [],
        cancel: true,
      );
    }
  }

  /// 補講情報の処理
  Future<void> _processSupplementaryLectures(
    DateTime selectTime,
    Map<int, Map<int, _CourseData>> periodData,
    Map<String, int> lessonIdMap,
  ) async {
    final supLectureData = await TimetableJSON.fetchSupLectures();

    for (final supLecture in supLectureData) {
      if (!_isSameDate(supLecture.date, selectTime)) {
        continue;
      }

      final lessonName = supLecture.lessonName;
      if (!lessonIdMap.containsKey(lessonName)) {
        continue;
      }

      final lessonId = lessonIdMap[lessonName]!;
      final existingCourse = periodData[supLecture.period]?[lessonId];

      if (existingCourse != null) {
        existingCourse.sup = true;
      }
    }
  }

  /// リソースIDをパース
  List<int> _parseResourceId(String resourceId) {
    try {
      return [int.parse(resourceId)];
    } on FormatException {
      return [];
    }
  }

  /// 日付が同じかどうかを判定
  bool _isSameDate(String dateString, DateTime target) {
    final date = DateTime.parse(dateString);
    return date.month == target.month && date.day == target.day;
  }

  /// periodDataをTimetableCourseに変換
  Map<int, List<TimetableCourse>> _convertPeriodDataToCourses(
    Map<int, Map<int, _CourseData>> periodData,
    Map<int, String> roomNameMap,
  ) {
    final returnData = <int, List<TimetableCourse>>{};
    periodData.forEach((period, courseMap) {
      final courses = courseMap.values.map((courseData) {
        // 部屋名を取得（複数ある場合はカンマ区切りで結合）
        final roomNames = courseData.resourceIds
            .map((id) => roomNameMap[id] ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
        final roomName = roomNames.isNotEmpty ? roomNames.join(', ') : '';

        // 授業タイプを判定
        TimetableCourseType type;
        if (courseData.cancel) {
          type = TimetableCourseType.cancelled;
        } else if (courseData.sup) {
          type = TimetableCourseType.madeUp;
        } else {
          type = TimetableCourseType.normal;
        }

        return TimetableCourse(
          lessonId: courseData.lessonId,
          kakomonLessonId: courseData.kakomonLessonId,
          slot: TimetableSlot.fromNumber(period),
          courseName: courseData.title,
          roomName: roomName,
          resourceIds: courseData.resourceIds,
          type: type,
        );
      }).toList();
      returnData[period] = courses;
    });
    return returnData;
  }

  Future<Map<DateTime, Map<int, List<TimetableCourse>>>>
  _getTimetables() async {
    final dates = _getDateRange();
    final twoWeekLessonSchedule = <DateTime, Map<int, List<TimetableCourse>>>{};
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
