import 'package:dotto/feature/search_course/search_course_viewmodel.dart';
import 'package:dotto/feature/search_course/widget/search_course_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchCourseResultSection extends ConsumerWidget {
  const SearchCourseResultSection({required this.onTapped, super.key});

  final void Function(Map<String, dynamic>) onTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(searchCourseViewModelProvider);

    if (viewModel.value?.searchResults == null) {
      return const SizedBox.shrink();
    }
    if (viewModel.value?.searchResults!.isNotEmpty ?? false) {
      return SearchCourseResult(
        records: viewModel.value?.searchResults ?? [],
        onTapped: onTapped,
      );
    }
    return const Center(
      child: Padding(padding: EdgeInsets.all(16), child: Text('見つかりませんでした')),
    );
  }
}
