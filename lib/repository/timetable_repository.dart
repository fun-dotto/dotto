import 'package:dotto/data/firebase/model/timetable_course_response.dart';
import 'package:dotto/data/firebase/room_api.dart';
import 'package:dotto/data/firebase/timetable_api.dart';
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

final class TimetableRepositoryImpl implements TimetableRepository {
  @override
  Future<List<Timetable>> getTimetables() async {
    try {
      final response = await TimetableAPI.getTimetables();
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
}
