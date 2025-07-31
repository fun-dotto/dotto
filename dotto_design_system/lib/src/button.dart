import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final class DottoButtonOverview extends StatelessWidget {
  const DottoButtonOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              DottoButton(onPressed: () {}, child: const Text('Button')),
              const DottoButton(onPressed: null, child: Text('Button')),
              const DottoButton(onPressed: null, child: null),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              DottoButton(
                onPressed: () {},
                type: DottoButtonType.outlined,
                child: const Text('Button'),
              ),
              const DottoButton(
                onPressed: null,
                type: DottoButtonType.outlined,
                child: Text('Button'),
              ),
              const DottoButton(
                onPressed: null,
                type: DottoButtonType.outlined,
                child: null,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              DottoButton(
                onPressed: () {},
                type: DottoButtonType.text,
                child: const Text('Button'),
              ),
              const DottoButton(
                onPressed: null,
                type: DottoButtonType.text,
                child: Text('Button'),
              ),
              const DottoButton(
                onPressed: null,
                type: DottoButtonType.text,
                child: null,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              DottoButton(
                onPressed: () {},
                shape: DottoButtonShape.circle,
                child: const Text('Button'),
              ),
              const DottoButton(
                onPressed: null,
                shape: DottoButtonShape.circle,
                child: Text('Button'),
              ),
              const DottoButton(
                onPressed: null,
                shape: DottoButtonShape.circle,
                child: null,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              DottoButton(
                onPressed: () {},
                type: DottoButtonType.outlined,
                shape: DottoButtonShape.circle,
                child: const Text('Button'),
              ),
              const DottoButton(
                onPressed: null,
                type: DottoButtonType.outlined,
                shape: DottoButtonShape.circle,
                child: Text('Button'),
              ),
              const DottoButton(
                onPressed: null,
                type: DottoButtonType.outlined,
                shape: DottoButtonShape.circle,
                child: null,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              DottoButton(
                onPressed: () {},
                type: DottoButtonType.text,
                shape: DottoButtonShape.circle,
                child: const Text('Button'),
              ),
              const DottoButton(
                onPressed: null,
                type: DottoButtonType.text,
                shape: DottoButtonShape.circle,
                child: Text('Button'),
              ),
              const DottoButton(
                onPressed: null,
                type: DottoButtonType.text,
                shape: DottoButtonShape.circle,
                child: null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

@widgetbook.UseCase(name: 'Button', type: DottoButtonOverview)
DottoButtonOverview button(BuildContext context) {
  return const DottoButtonOverview();
}
