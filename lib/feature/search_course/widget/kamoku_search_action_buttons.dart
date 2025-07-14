import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto/theme/v1/color_fun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class KamokuSearchActionButtons extends ConsumerWidget {
  const KamokuSearchActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: TextButton(
            onPressed: ref.read(kamokuSearchControllerProvider.notifier).reset,
            child: const Text('リセット'),
          ),
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: customFunColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await ref.read(kamokuSearchControllerProvider.notifier).search();
            },
            child: const SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '科目検索',
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(
                    Icons.search,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
