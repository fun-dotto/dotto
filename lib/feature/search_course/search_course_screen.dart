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

  Widget _body(AsyncValue<SearchCourseViewModelState> viewModelAsync) {
    switch (viewModelAsync) {
      case AsyncData(:final value):
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => value.focusNode.unfocus(),
          child: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchCourseBox(),
                SearchCourseFilterSection(),
                SearchCourseActionButtons(),
                SearchCourseResultSection(),
              ],
            ),
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
      body: _body(viewModelAsync),
    );
  }
}
