import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'is_filtered_only_taking_course_cancellation_controller.g.dart';

@riverpod
final class IsFilteredOnlyTakingCourseCancellationNotifier extends _$IsFilteredOnlyTakingCourseCancellationNotifier {
  @override
  bool build() {
    return true;
  }

  void toggle() {
    state = !state;
  }
}
