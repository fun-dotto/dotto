import 'package:dotto/feature/search_course/search_course_viewmodel.dart';
import 'package:dotto_design_system/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchCourseBox extends ConsumerWidget {
  const SearchCourseBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(searchCourseViewModelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DottoTextField(
        controller:
            viewModel.value?.textEditingController ?? TextEditingController(),
        focusNode: viewModel.value?.focusNode ?? FocusNode(),
        placeholder: '科目名で検索',
        onCleared: () {
          ref.read(searchCourseViewModelProvider.notifier).setSearchWord('');
        },
        onChanged: ref
            .read(searchCourseViewModelProvider.notifier)
            .setSearchWord,
        onSubmitted: (_) {
          ref.read(searchCourseViewModelProvider.notifier).search();
        },
      ),
    );
  }
}
