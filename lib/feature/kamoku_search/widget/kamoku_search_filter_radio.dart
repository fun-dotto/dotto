import 'package:dotto/feature/kamoku_search/controller/kamoku_search_controller.dart';
import 'package:dotto/feature/kamoku_search/domain/kamoku_search_choices.dart';
import 'package:dotto/importer.dart';

final class KamokuSearchFilterRadio extends ConsumerWidget {
  const KamokuSearchFilterRadio({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: KamokuSearchChoices.senmonKyoyo.choice
                  .map((e) => SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            Radio(
                              value: KamokuSearchChoices.senmonKyoyo.choice
                                  .indexOf(e),
                              onChanged: ref
                                  .read(kamokuSearchControllerProvider.notifier)
                                  .radioOnChanged,
                              groupValue:
                                  kamokuSearchController.senmonKyoyoStatus,
                            ),
                            Text(e),
                          ],
                        ),
                      ))
                  .toList() +
              [const SizedBox(width: 10)],
        ),
      ),
    );
  }
}
