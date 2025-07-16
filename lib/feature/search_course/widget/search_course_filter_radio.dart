import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:dotto/feature/search_course/widget/search_course_checkbox_item.dart';
import 'package:dotto/importer.dart';

final class SearchCourseFilterRadio extends ConsumerWidget {
  const SearchCourseFilterRadio({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: SearchCourseFilterOptions.largeCategory.labels
              .asMap()
              .entries
              .map((entry) => SearchCourseCheckboxItem(
                    filterOption: SearchCourseFilterOptions.largeCategory,
                    index: entry.key,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
