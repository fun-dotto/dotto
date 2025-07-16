import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:dotto/feature/search_course/widget/search_course_checkbox_item.dart';
import 'package:dotto/importer.dart';

final class SearchCourseFilterCheckbox extends ConsumerWidget {
  const SearchCourseFilterCheckbox(
      {required this.filterOption, super.key});

  final SearchCourseFilterOptions filterOption;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filterOption.labels
              .asMap()
              .entries
              .map((entry) => SearchCourseCheckboxItem(
                    filterOption: filterOption,
                    index: entry.key,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
