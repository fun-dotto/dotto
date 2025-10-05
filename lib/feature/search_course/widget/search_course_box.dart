import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto_design_system/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SearchCourseBox extends ConsumerWidget {
  const SearchCourseBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DottoTextField(
        controller: kamokuSearchController.textEditingController,
        focusNode: kamokuSearchController.searchBoxFocusNode,
        placeholder: '科目名で検索',
        onCleared: () {
          ref.read(kamokuSearchControllerProvider.notifier).setSearchWord('');
        },
        onChanged: ref
            .read(kamokuSearchControllerProvider.notifier)
            .setSearchWord,
        onSubmitted: (_) {
          ref.read(kamokuSearchControllerProvider.notifier).search();
        },
      ),
    );
  }
}
