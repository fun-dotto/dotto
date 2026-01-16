import 'package:collection/collection.dart';
import 'package:dotto/domain/timetable.dart';
import 'package:dotto/feature/home/component/timetable_view.dart';
import 'package:dotto/helper/date_formatter.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class TimetableCalendarView extends StatelessWidget {
  const TimetableCalendarView({required this.timetables, super.key});
  final List<Timetable> timetables;

  Widget _dateButton({
    required DateTime date,
    required bool isSelected,
    required void Function() onPressed,
  }) {
    return SizedBox(
      width: 48,
      height: 48,
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 16),
          foregroundColor: isSelected
              ? SemanticColor.light.labelTertiary
              : SemanticColor.light.labelSecondary,
          backgroundColor: isSelected
              ? SemanticColor.light.accentPrimary
              : SemanticColor.light.backgroundSecondary,
          overlayColor: SemanticColor.light.accentPrimary,
          side: BorderSide(color: SemanticColor.light.borderPrimary),
          shape: const CircleBorder(),
          fixedSize: const Size(48, 48),
        ),
        onPressed: onPressed,
        child: Text(DateFormatter.dayOfMonth(date)),
      ),
    );
  }

  Widget _dateButtons({
    required List<DateTime> dates,
    required DateTime selectedDate,
    required void Function(DateTime) onPressed,
  }) {
    return Column(
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: dates
              .map(
                (date) => SizedBox(
                  width: 48,
                  child: Center(
                    child: Text(
                      DateFormatter.dayOfWeek(date),
                      style: TextStyle(
                        fontSize: 14,
                        color: SemanticColor.light.labelPrimary,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: dates
              .map(
                (date) => _dateButton(
                  date: date,
                  isSelected: selectedDate == date,
                  onPressed: () {
                    onPressed(date);
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final selectedDate = DateTime(now.year, now.month, now.day);
    final dates = List.generate(
      5,
      (index) => monday.add(Duration(days: index)),
    );
    return Column(
      spacing: 8,
      children: [
        _dateButtons(
          dates: dates,
          selectedDate: selectedDate,
          onPressed: (date) {},
        ),
        TimetableView(
          timetable: timetables.firstWhereOrNull(
            (timetable) => timetable.date.isAtSameMomentAs(selectedDate),
          ),
        ),
      ],
    );
  }
}
