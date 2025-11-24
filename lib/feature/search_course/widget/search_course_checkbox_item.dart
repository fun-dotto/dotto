import 'package:dotto/feature/search_course/controller/search_course_viewmodel.dart';
import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchCourseCheckboxItem extends ConsumerWidget {
  const SearchCourseCheckboxItem({
    required this.filterOption,
    required this.index,
    super.key,
  });

  final SearchCourseFilterOptions filterOption;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(searchCourseViewModelProvider);

    return viewModel.when(
      data: (state) {
        return SizedBox(
          width: 100,
          child: Row(
            children: [
              Checkbox(
                value:
                    viewModel.value?.filterSelections[filterOption]?[index] ??
                    false,
                onChanged: (value) {
                  ref
                      .read(searchCourseViewModelProvider.notifier)
                      .checkboxOnChanged(
                        value: value,
                        filterOption: filterOption,
                        index: index,
                      );
                },
              ),
              Text(filterOption.labels[index]),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
