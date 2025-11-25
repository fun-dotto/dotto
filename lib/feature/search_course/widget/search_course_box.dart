import 'package:dotto_design_system/component/text_field.dart';
import 'package:flutter/material.dart';

final class SearchCourseBox extends StatelessWidget {
  const SearchCourseBox({
    required this.textEditingController,
    required this.focusNode,
    required this.onCleared,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final void Function() onCleared;
  final void Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DottoTextField(
        controller: textEditingController,
        focusNode: focusNode,
        placeholder: '科目名で検索',
        onCleared: onCleared,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
