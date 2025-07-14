import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto/theme/v1/color_fun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchCourseActionButtons extends ConsumerWidget {
  const SearchCourseActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          // TextButton(
          //   onPressed: ref.read(kamokuSearchControllerProvider.notifier).reset,
          //   child: const Text('フィルタをクリア'),
          // ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: customFunColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await ref.read(kamokuSearchControllerProvider.notifier).search();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                Text(
                  '検索',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 8),
                Column(
                  children: [
                    SizedBox(height: 4),
                    Icon(
                      Icons.search,
                      size: 24,
                    ),
                  ],
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
