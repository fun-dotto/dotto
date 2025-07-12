import 'package:dotto/feature/kamoku_search/controller/kamoku_search_controller.dart';
import 'package:dotto/importer.dart';

final class KamokuSearchFilterRadio extends ConsumerWidget {
  const KamokuSearchFilterRadio({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);
    final kamokuSearchControllerNotifier =
        ref.watch(kamokuSearchControllerProvider.notifier);
    return Align(
      alignment: const AlignmentDirectional(-1, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0;
                i < kamokuSearchControllerNotifier.checkboxSenmonKyoyo.length;
                i++)
              SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Radio(
                      value: i,
                      onChanged: kamokuSearchControllerNotifier.radioOnChanged,
                      groupValue: kamokuSearchController.senmonKyoyoStatus,
                    ),
                    Text(kamokuSearchControllerNotifier.checkboxSenmonKyoyo[i]),
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
