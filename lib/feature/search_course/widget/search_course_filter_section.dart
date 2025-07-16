import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:dotto/feature/search_course/widget/search_course_filter_checkbox.dart';
import 'package:dotto/feature/search_course/widget/search_course_filter_radio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchCourseFilterSection extends ConsumerWidget {
  const SearchCourseFilterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);

    return Column(
      children: [
        const SearchCourseFilterRadio(),
        ...SearchCourseFilterOptions.values
            .where((e) => e != SearchCourseFilterOptions.largeCategory)
            .map(
          (e) => Visibility(
            visible: kamokuSearchController.visibilityStatus.contains(e),
            child: SearchCourseFilterCheckbox(
              filterOption: e,
            ),
          ),
        ),
      ],
    );
  }
}
