import 'package:dotto/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/timetable/widget/timetable_is_over_selected_snack_bar.dart';
import 'package:dotto/importer.dart';

final class AddCourseButton extends ConsumerWidget {
  const AddCourseButton({required this.lessonId, super.key});

  final int lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalLessonIdList = ref.watch(personalLessonIdListProvider);

    return IconButton(
      icon: Icon(
        Icons.playlist_add,
        color: personalLessonIdList.contains(lessonId)
            ? Colors.green
            : Colors.black,
      ),
      onPressed: () async {
        if (!personalLessonIdList.contains(lessonId)) {
          if (await TimetableRepository().isOverSeleted(lessonId, ref)) {
            if (context.mounted) {
              timetableIsOverSelectedSnackBar(context);
            }
          } else {
            TimetableRepository()
                .addPersonalTimeTableList(lessonId, ref)
                .ignore();
          }
        } else {
          TimetableRepository()
              .removePersonalTimeTableList(lessonId, ref)
              .ignore();
        }
        ref.read(twoWeekTimeTableDataProvider.notifier).state =
            await TimetableRepository().get2WeekLessonSchedule(ref);
      },
    );
  }
}
