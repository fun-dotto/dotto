import 'package:dotto/feature/search_course/widget/search_course_action_buttons.dart';
import 'package:dotto/feature/search_course/widget/search_course_box.dart';
import 'package:dotto/feature/search_course/widget/search_course_filter_section.dart';
import 'package:dotto/feature/search_course/widget/search_course_result_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchCourseScreen extends ConsumerWidget {
  const SearchCourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchCourseBox(),
                SearchCourseFilterSection(),
                SearchCourseActionButtons(),
                SearchCourseResultSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
