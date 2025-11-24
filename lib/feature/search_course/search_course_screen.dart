import 'package:dotto/feature/search_course/domain/search_course_filter_option_choice.dart';
import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:dotto/feature/search_course/search_course_viewmodel.dart';
import 'package:dotto/feature/search_course/search_course_viewmodel_state.dart';
import 'package:dotto/feature/search_course/widget/search_course_action_buttons.dart';
import 'package:dotto/feature/search_course/widget/search_course_box.dart';
import 'package:dotto/feature/search_course/widget/search_course_filter_section.dart';
import 'package:dotto/feature/search_course/widget/search_course_result_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchCourseScreen extends ConsumerWidget {
  const SearchCourseScreen({super.key});

  Widget _body({
    required AsyncValue<SearchCourseViewModelState> viewModelAsync,
    required void Function(
      SearchCourseFilterOptions,
      SearchCourseFilterOptionChoice,
      bool?,
    )
    onChanged,
    required void Function() onCleared,
    required void Function() onSearchButtonTapped,
  }) {
    switch (viewModelAsync) {
      case AsyncData(:final value):
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchCourseBox(
                textEditingController: value.textEditingController,
                focusNode: value.focusNode,
                onCleared: onCleared,
                onSubmitted: (value) => onSearchButtonTapped(),
              ),
              SearchCourseFilterSection(
                visibilityStatus: value.visibilityStatus,
                selectedChoicesMap: value.selectedChoicesMap,
                onChanged: onChanged,
              ),
              SearchCourseActionButtons(
                onSearchButtonTapped: onSearchButtonTapped,
              ),
              const SearchCourseResultSection(),
            ],
          ),
        );
      case AsyncLoading():
        return const Center(child: CircularProgressIndicator());
      case AsyncError(:final error):
        return Center(child: Text('Error: $error'));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelAsync = ref.watch(searchCourseViewModelProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('科目'), centerTitle: false),
      body: _body(
        viewModelAsync: viewModelAsync,
        onChanged: (filterOption, choice, isSelected) => ref
            .read(searchCourseViewModelProvider.notifier)
            .onCheckboxTapped(
              filterOption: filterOption,
              choice: choice,
              isSelected: isSelected,
            ),
        onCleared: () =>
            ref.read(searchCourseViewModelProvider.notifier).onCleared(),
        onSearchButtonTapped: () => ref
            .read(searchCourseViewModelProvider.notifier)
            .onSearchButtonTapped(),
      ),
    );
  }
}
