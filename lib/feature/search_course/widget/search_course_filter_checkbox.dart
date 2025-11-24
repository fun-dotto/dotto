import 'package:dotto/feature/search_course/domain/search_course_filter_option_choice.dart';
import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:dotto/feature/search_course/widget/search_course_checkbox_item.dart';
import 'package:flutter/material.dart';

final class SearchCourseFilterCheckbox extends StatelessWidget {
  const SearchCourseFilterCheckbox({
    required this.filterOption,
    required this.selectedChoices,
    required this.onChanged,
    super.key,
  });

  final SearchCourseFilterOptions filterOption;
  final List<SearchCourseFilterOptionChoice> selectedChoices;
  final void Function(SearchCourseFilterOptionChoice, bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filterOption.choices
              .map(
                (e) => SearchCourseCheckboxItem(
                  label: e.label,
                  isSelected: selectedChoices.contains(e),
                  onChanged: (value) => onChanged(e, value),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
