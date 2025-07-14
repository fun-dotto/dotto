import 'package:dotto/feature/kamoku_search/controller/kamoku_search_controller.dart';
import 'package:dotto/feature/kamoku_search/domain/kamoku_search_choices.dart';
import 'package:dotto/importer.dart';

final class KamokuSearchFilterCheckbox extends ConsumerWidget {
  const KamokuSearchFilterCheckbox(
      {required this.kamokuSearchChoices, super.key});

  final KamokuSearchChoices kamokuSearchChoices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);
    final checkedList =
        kamokuSearchController.checkboxStatusMap[kamokuSearchChoices]!;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < kamokuSearchChoices.choice.length; i++)
              SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Checkbox(
                      value: checkedList[i],
                      onChanged: (value) {
                        ref
                            .read(kamokuSearchControllerProvider.notifier)
                            .checkboxOnChanged(
                              value: value,
                              kamokuSearchChoices: kamokuSearchChoices,
                              index: i,
                            );
                      },
                    ),
                    Text(kamokuSearchChoices.displayString?[i] ??
                        kamokuSearchChoices.choice[i]),
                  ],
                ),
              ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
