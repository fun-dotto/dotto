import 'package:dotto/feature/search_course/domain/kamoku_search_choices.dart';
import 'package:dotto/feature/search_course/widget/search_course_checkbox_item.dart';
import 'package:dotto/importer.dart';

final class SearchCourseFilterCheckbox extends ConsumerWidget {
  const SearchCourseFilterCheckbox(
      {required this.kamokuSearchChoices, super.key});

  final KamokuSearchChoices kamokuSearchChoices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: kamokuSearchChoices.choice
              .asMap()
              .entries
              .map((entry) => SearchCourseCheckboxItem(
                    kamokuSearchChoices: kamokuSearchChoices,
                    index: entry.key,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
