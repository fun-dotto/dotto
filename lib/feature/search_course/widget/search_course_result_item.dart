import 'package:dotto/feature/kamoku_detail/kamoku_detail_screen.dart';
import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto/feature/search_course/widget/add_course_button.dart';
import 'package:dotto/theme/v1/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchCourseResultItem extends ConsumerWidget {
  const SearchCourseResultItem({
    required this.record,
    required this.weekPeriodString,
    super.key,
  });

  final Map<String, dynamic> record;
  final String weekPeriodString;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);
    final lessonId = record['LessonId'] as int;

    return ListTile(
      title: Text(record['授業名'] as String? ?? ''),
      subtitle: Text(weekPeriodString),
      onTap: () async {
        await Navigator.of(context).push(
          PageRouteBuilder<void>(
            pageBuilder: (context, animation, secondaryAnimation) {
              return KamokuDetailScreen(
                lessonId: lessonId,
                lessonName: record['授業名'] as String,
                kakomonLessonId: record['過去問'] as int?,
              );
            },
            transitionsBuilder: fromRightAnimation,
          ),
        );
        kamokuSearchController.searchBoxFocusNode.unfocus();
      },
      trailing: const Icon(Icons.chevron_right),
      leading: AddCourseButton(lessonId: lessonId),
    );
  }
}
