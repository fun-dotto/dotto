import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_cancellation.freezed.dart';
part 'course_cancellation.g.dart';

@freezed
abstract class CourseCancellation with _$CourseCancellation {
  const factory CourseCancellation({
    required int lessonId,
    required String date,
    required int period,
    required String lessonName,
    required String campus,
    required String staff,
    required String comment,
    required String type,
  }) = _CourseCancellation;

  factory CourseCancellation.fromJson(Map<String, dynamic> json) => _$CourseCancellationFromJson(json);
}
