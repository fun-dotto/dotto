import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_course_response.freezed.dart';
part 'timetable_course_response.g.dart';

@freezed
abstract class TimetableCourseResponse with _$TimetableCourseResponse {
  //
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TimetableCourseResponse({
    required int lessonId,
    required String title,
    required int? kakomonLessonId,
    required List<int> resourseIds,
    @Default(false) bool cancel,
    @Default(false) bool sup,
  }) = _TimetableCourseResponse;

  factory TimetableCourseResponse.fromJson(Map<String, Object?> json) =>
      _$TimetableCourseResponseFromJson(json);
}
