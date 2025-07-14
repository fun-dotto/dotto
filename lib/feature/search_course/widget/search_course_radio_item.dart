import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto/importer.dart';

final class SearchCourseRadioItem extends ConsumerWidget {
  const SearchCourseRadioItem({
    required this.index,
    required this.label,
    super.key,
  });

  final int index;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);

    return SizedBox(
      width: 100,
      child: Row(
        children: [
          Radio(
            value: index,
            onChanged: ref
                .read(kamokuSearchControllerProvider.notifier)
                .radioOnChanged,
            groupValue: kamokuSearchController.senmonKyoyoStatus,
          ),
          Text(label),
        ],
      ),
    );
  }
}
