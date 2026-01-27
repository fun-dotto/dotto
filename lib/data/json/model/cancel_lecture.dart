import 'package:freezed_annotation/freezed_annotation.dart';

part 'cancel_lecture.freezed.dart';
part 'cancel_lecture.g.dart';

@freezed
abstract class CancelLecture with _$CancelLecture {
  const factory CancelLecture({
    required String date,
    required String lessonName,
    required int period,
  }) = _CancelLecture;

  factory CancelLecture.fromJson(Map<String, dynamic> json) =>
      _$CancelLectureFromJson(json);
}
