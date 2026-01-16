import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable.freezed.dart';

@freezed
abstract class Timetable with _$Timetable {
  const factory Timetable({required DateTime date}) = _Timetable;
}
