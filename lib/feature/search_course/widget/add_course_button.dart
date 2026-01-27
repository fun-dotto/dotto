import 'package:dotto/feature/timetable/controller/personal_lesson_id_list_controller.dart';
import 'package:dotto/repository/timetable_repository.dart';
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
          icon: Icon(
            Icons.playlist_add,
            color: data.contains(lessonId) ? Colors.green : Colors.black,
          ),
          onPressed: () async {
            final repository = ref.read(timetableRepositoryProvider);
            final notifier = ref.read(personalLessonIdListProvider.notifier);
            if (!data.contains(lessonId)) {
              if (await notifier.isOverSelected(lessonId)) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).removeCurrentSnackBar();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text('3科目以上選択することはできません'),
                    ),
                  );
                }
              } else {
                await repository.addLesson(lessonId);
                ref.invalidate(personalLessonIdListProvider);
              }
            } else {
              await repository.removeLesson(lessonId);
              ref.invalidate(personalLessonIdListProvider);
            }
          },
        );
      },
      error: (error, stack) =>
          IconButton(icon: const Icon(Icons.playlist_add), onPressed: () {}),
      loading: () =>
          IconButton(icon: const Icon(Icons.playlist_add), onPressed: () {}),
    );
  }
}
