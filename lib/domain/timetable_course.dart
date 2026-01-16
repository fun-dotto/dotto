import 'package:dotto/domain/timetable_course_type.dart';
import 'package:dotto/domain/timetable_slot.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_course.freezed.dart';

@freezed
abstract class TimetableCourse with _$TimetableCourse {
  const factory TimetableCourse({
    // 時限
    required TimetableSlot slot,
    // Deprecated: 科目ID
    required int lessonId,
    // 科目名
    required String courseName,
    // 部屋名
    required String roomName,
    // 通常・休講・補講
    required TimetableCourseType type,
  }) = _TimetableCourse;
}
