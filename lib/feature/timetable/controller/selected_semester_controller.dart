import 'package:dotto/domain/semester.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_semester_controller.g.dart';

@riverpod
final class SelectedSemesterNotifier extends _$SelectedSemesterNotifier {
  @override
  Semester build() {
    final now = DateTime.now();
    if ((now.month >= 9) || (now.month <= 2)) {
      return Semester.fall;
    }
    return Semester.spring;
  }

  Semester get value => state;

  set value(Semester newValue) {
    state = newValue;
  }
}
