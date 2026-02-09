import 'package:flutter/material.dart';

final class SearchCourseCheckboxItem extends StatelessWidget {
  const SearchCourseCheckboxItem({required this.label, required this.isSelected, required this.onChanged, super.key});

  final String label;
  final bool isSelected;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Row(
        children: [
          Checkbox(value: isSelected, onChanged: onChanged),
          Text(label),
        ],
      ),
    );
  }
}
