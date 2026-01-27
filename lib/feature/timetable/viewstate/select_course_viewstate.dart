import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/timetable_slot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_course_viewstate.freezed.dart';

@freezed
abstract class SelectCourseViewState with _$SelectCourseViewState {
  const factory SelectCourseViewState({
    required Semester semester,
    required DayOfWeek dayOfWeek,
    required TimetableSlot period,
    required AsyncValue<List<Map<String, dynamic>>> availableCourses,
    required AsyncValue<List<int>> personalLessonIdList,
  }) = _SelectCourseViewState;
}
