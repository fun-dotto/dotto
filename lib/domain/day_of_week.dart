import 'package:flutter/material.dart';

enum DayOfWeek {
  monday(label: '月', color: Colors.black),
  tuesday(label: '火', color: Colors.black),
  wednesday(label: '水', color: Colors.black),
  thursday(label: '木', color: Colors.black),
  friday(label: '金', color: Colors.black),
  saturday(label: '土', color: Colors.blue),
  sunday(label: '日', color: Colors.red);

  const DayOfWeek({required this.label, required this.color});

  final String label;
  final Color color;

  int get number => index + 1;

  static List<DayOfWeek> get weekdays => [
    DayOfWeek.monday,
    DayOfWeek.tuesday,
    DayOfWeek.wednesday,
    DayOfWeek.thursday,
    DayOfWeek.friday,
  ];

  static DayOfWeek fromNumber(int number) {
    return DayOfWeek.values[number - 1];
  }

  static DayOfWeek fromDateTime(DateTime dateTime) {
    return DayOfWeek.values[dateTime.weekday - 1];
  }
}
