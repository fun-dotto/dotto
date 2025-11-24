import 'package:dotto/feature/search_course/widget/add_course_button.dart';
import 'package:flutter/material.dart';

final class SearchCourseResultItem extends StatelessWidget {
  const SearchCourseResultItem({
    required this.lessonId,
    required this.lessonName,
    required this.weekPeriodString,
    required this.onTapped,
    super.key,
  });

  final int lessonId;
  final String lessonName;
  final String weekPeriodString;
  final void Function() onTapped;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(lessonName),
      subtitle: Text(weekPeriodString),
      onTap: onTapped,
      trailing: const Icon(Icons.chevron_right),
      leading: AddCourseButton(lessonId: lessonId),
    );
  }
}
