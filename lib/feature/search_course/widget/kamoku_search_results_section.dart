import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto/feature/search_course/widget/kamoku_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class KamokuSearchResultsSection extends ConsumerWidget {
  const KamokuSearchResultsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);

    if (kamokuSearchController.searchResults != null) {
      if (kamokuSearchController.searchResults!.isNotEmpty) {
        return KamokuSearchResults(
          records: kamokuSearchController.searchResults!,
        );
      } else {
        return const Center(
          child: Text('検索結果は見つかりませんでした'),
        );
      }
    }

    return const SizedBox.shrink();
  }
}
