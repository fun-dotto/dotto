import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchCourseActionButtons extends ConsumerWidget {
  const SearchCourseActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: DottoButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();
          await ref.read(kamokuSearchControllerProvider.notifier).search();
        },
        child: const Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('検索'), Icon(Icons.search)],
        ),
      ),
    );
  }
}
