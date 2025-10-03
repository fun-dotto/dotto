import 'package:flutter/material.dart';

final class DottoTextField extends StatelessWidget {
  const DottoTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.onCleared,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final VoidCallback? onCleared;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: placeholder,
        suffixIcon: controller?.text.isNotEmpty ?? false
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller?.clear();
                  onCleared?.call();
                },
              )
            : null,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
