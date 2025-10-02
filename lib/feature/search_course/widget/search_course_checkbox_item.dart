import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:dotto/importer.dart';

final class SearchCourseCheckboxItem extends ConsumerWidget {
  const SearchCourseCheckboxItem({
    required this.filterOption,
    required this.index,
    super.key,
  });

  final SearchCourseFilterOptions filterOption;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);
    final checkedList =
        kamokuSearchController.filterSelections[filterOption]!;

    return SizedBox(
      width: 100,
      child: Row(
        children: [
          Checkbox(
            value: checkedList[index],
            onChanged: (value) {
              ref
                  .read(kamokuSearchControllerProvider.notifier)
                  .checkboxOnChanged(
                    value: value,
                    filterOption: filterOption,
                    index: index,
                  );
            },
          ),
          Text(filterOption.labels[index]),
        ],
      ),
    );
  }
}
