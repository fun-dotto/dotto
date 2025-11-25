import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';

final class SearchCourseActionButtons extends StatelessWidget {
  const SearchCourseActionButtons({
    required this.onSearchButtonTapped,
    super.key,
  });

  final void Function() onSearchButtonTapped;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DottoButton(
        onPressed: onSearchButtonTapped,
        child: const Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('検索'), Icon(Icons.search)],
        ),
      ),
    );
  }
}
