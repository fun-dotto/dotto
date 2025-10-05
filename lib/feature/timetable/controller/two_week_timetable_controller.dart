import 'package:dotto/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'two_week_timetable_controller.g.dart';

@riverpod
final class TwoWeekTimetableNotifier extends _$TwoWeekTimetableNotifier {
  @override
  Future<Map<DateTime, Map<int, List<TimetableCourse>>>> build() async {
    return TimetableRepository().get2WeekLessonSchedule();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return TimetableRepository().get2WeekLessonSchedule();
    });
  }
}
