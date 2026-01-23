import 'package:dotto_design_system/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final class DottoTextFieldOverview extends StatelessWidget {
  const DottoTextFieldOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          DottoTextField(placeholder: 'Type here...'),
        ],
      ),
    );
  }
}

@widgetbook.UseCase(name: 'TextField', type: DottoTextFieldOverview)
DottoTextFieldOverview textField(BuildContext context) {
  return const DottoTextFieldOverview();
}
