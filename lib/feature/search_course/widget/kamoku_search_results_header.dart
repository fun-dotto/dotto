import 'package:flutter/material.dart';

final class KamokuSearchResultsHeader extends StatelessWidget {
  const KamokuSearchResultsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Text(
          '結果一覧',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
    );
  }
}
