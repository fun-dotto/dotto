import 'package:dotto/domain/timetable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_viewstate.freezed.dart';

@freezed
abstract class HomeViewState with _$HomeViewState {
  const factory HomeViewState({required List<Timetable> timetables}) =
      _HomeViewState;
}
