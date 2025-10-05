import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'personal_lesson_id_list_controller.g.dart';

@riverpod
final class PersonalLessonIdListNotifier
    extends _$PersonalLessonIdListNotifier {
  @override
  List<int> build() {
    return [];
  }

  void add(int lessonId) {
    state = [...state, lessonId];
  }

  void remove(int lessonId) {
    state = state.where((element) => element != lessonId).toList();
  }

  void set(List<int> lessonIdList) {
    state = [...lessonIdList];
  }
}
