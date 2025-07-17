import 'package:dotto/feature/assignment/domain/assignment.dart';
import 'package:dotto/feature/assignment/domain/assignment_list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignment_state.freezed.dart';

@freezed
abstract class AssignmentState with _$AssignmentState {
  factory AssignmentState({
    @Default([]) List<int> doneList,
    @Default([]) List<int> alertList,
    @Default([]) List<int> deletedList,
    @Default([]) List<AssignmentList> data,
    @Default([]) List<AssignmentList> deleted,
    @Default([]) List<AssignmentList> filteredData,
    @Default([]) List<Assignment> deletedAssignment,
  }) = _AssignmentState;
}
