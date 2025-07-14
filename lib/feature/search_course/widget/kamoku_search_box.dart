import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto/importer.dart';

final class KamokuSearchBox extends ConsumerWidget {
  const KamokuSearchBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);
    return TextField(
      controller: kamokuSearchController.textEditingController,
      focusNode: kamokuSearchController.searchBoxFocusNode,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: '科目名で検索',
        suffixIcon: kamokuSearchController.textEditingController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  kamokuSearchController.textEditingController.clear();
                  ref
                      .read(kamokuSearchControllerProvider.notifier)
                      .setSearchWord('');
                },
              )
            : null,
      ),
      onChanged:
          ref.read(kamokuSearchControllerProvider.notifier).setSearchWord,
    );
  }
}
