import 'package:dotto_design_system/component/text_field.dart';
import 'package:flutter/material.dart';

final class MapSearchBar extends StatelessWidget {
  const MapSearchBar({
    required this.textEditingController,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onCleared,
    super.key,
  });

  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;
  final void Function() onCleared;

  @override
  Widget build(BuildContext context) {
    return DottoTextField(
      controller: textEditingController,
      focusNode: focusNode,
      placeholder: '部屋名、教員名、メールアドレスで検索',
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onCleared: onCleared,
    );
  }
}
