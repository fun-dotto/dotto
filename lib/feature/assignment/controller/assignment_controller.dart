import 'package:dotto/feature/assignment/domain/assignment_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'assignment_controller.g.dart';

@riverpod
final class AssignmentNotifier extends _$AssignmentNotifier {
  @override
  Future<AssignmentState> build() async {
    return AssignmentState();
  }
}
