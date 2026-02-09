import 'package:dotto/feature/timetable/controller/personal_lesson_id_list_controller.dart';
import 'package:dotto/feature/timetable/controller/two_week_timetable_controller.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/timetable/widget/timetable_is_over_selected_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class AddCourseButton extends ConsumerWidget {
  const AddCourseButton({required this.lessonId, super.key});

  final int lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalLessonIdList = ref.watch(personalLessonIdListProvider);

    return personalLessonIdList.when(
      data: (data) {
        return IconButton(
          icon: Icon(Icons.playlist_add, color: data.contains(lessonId) ? Colors.green : Colors.black),
          onPressed: () async {
            if (!data.contains(lessonId)) {
              if (await TimetableRepository().isOverSeleted(lessonId, ref)) {
                if (context.mounted) {
                  timetableIsOverSelectedSnackBar(context);
                }
              } else {
                TimetableRepository().addPersonalTimetableList(lessonId, ref).ignore();
              }
            } else {
              TimetableRepository().removePersonalTimetableList(lessonId, ref).ignore();
            }
            await ref.read(twoWeekTimetableProvider.notifier).refresh();
          },
        );
      },
      error: (error, stack) => IconButton(icon: const Icon(Icons.playlist_add), onPressed: () {}),
      loading: () => IconButton(icon: const Icon(Icons.playlist_add), onPressed: () {}),
    );
  }
}
