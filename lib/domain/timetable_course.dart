import 'package:dotto/domain/timetable_course_type.dart';
import 'package:dotto/domain/timetable_slot.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_course.freezed.dart';

@freezed
abstract class TimetableCourse with _$TimetableCourse {
  const factory TimetableCourse({
    required TimetableSlot slot, // 時限
    required int lessonId, // Deprecated: 科目ID
    required String courseName, // 科目名
    required String roomName, // 部屋名
    @Default(TimetableCourseType.normal) TimetableCourseType type, // 通常・休講・補講
  }) = _TimetableCourse;
}
