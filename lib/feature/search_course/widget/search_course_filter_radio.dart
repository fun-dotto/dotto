import 'package:dotto/feature/search_course/domain/kamoku_search_choices.dart';
import 'package:dotto/feature/search_course/widget/search_course_radio_item.dart';
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
          children: KamokuSearchChoices.senmonKyoyo.choice
              .asMap()
              .entries
              .map((entry) => SearchCourseRadioItem(
                    index: entry.key,
                    label: entry.value,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
