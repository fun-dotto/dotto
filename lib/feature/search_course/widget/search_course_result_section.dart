import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto/feature/search_course/widget/search_course_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchCourseResultSection extends ConsumerWidget {
  const SearchCourseResultSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);

    if (kamokuSearchController.searchResults == null) {
      return const SizedBox.shrink();
    }
    if (kamokuSearchController.searchResults!.isNotEmpty) {
      return SearchCourseResult(
        records: kamokuSearchController.searchResults!,
      );
    }
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('見つかりませんでした'),
      ),
    );
  }
}
