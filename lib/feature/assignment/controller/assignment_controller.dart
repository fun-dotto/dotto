import 'package:dotto/feature/assignment/domain/assignment_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assignmentControllerProvider =
    AsyncNotifierProvider<AssignmentController, AssignmentState>(
        AssignmentController.new);

final class AssignmentController extends AsyncNotifier<AssignmentState> {
  @override
  Future<AssignmentState> build() async {
    return AssignmentState();
  }
}
