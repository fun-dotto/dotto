import 'package:dotto/feature/assignment/domain/assignment.dart';
import 'package:dotto/feature/assignment/domain/assignment_list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignment_state.freezed.dart';

@freezed
abstract class AssignmentState with _$AssignmentState {
  factory AssignmentState({
    @Default([]) List<int> doneAssignmentIds,
    @Default([]) List<int> alertAssignmentIds,
    @Default([]) List<int> hiddenAssignmentIds,
    @Default([]) List<AssignmentList> assignments,
    @Default([]) List<AssignmentList> deletedAssignments,
    @Default([]) List<AssignmentList> filteredAssignments,
    @Default([]) List<Assignment> deletedAssignment,
  }) = _AssignmentState;
}
