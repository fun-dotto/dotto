import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto/feature/search_course/domain/kamoku_search_choices.dart';
import 'package:dotto/importer.dart';

final class SearchCourseCheckboxItem extends ConsumerWidget {
  const SearchCourseCheckboxItem({
    required this.kamokuSearchChoices,
    required this.index,
    super.key,
  });

  final KamokuSearchChoices kamokuSearchChoices;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);
    final checkedList =
        kamokuSearchController.checkboxStatusMap[kamokuSearchChoices]!;

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
                    kamokuSearchChoices: kamokuSearchChoices,
                    index: index,
                  );
            },
          ),
          Text(kamokuSearchChoices.displayString?[index] ??
              kamokuSearchChoices.choice[index]),
        ],
      ),
    );
  }
}
