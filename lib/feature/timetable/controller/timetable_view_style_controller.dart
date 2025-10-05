import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'timetable_view_style_controller.g.dart';

@riverpod
final class TimetableViewStyleNotifier extends _$TimetableViewStyleNotifier {
  @override
  TimetableViewStyle build() {
    return TimetableViewStyle.table;
  }

  void toggle() {
    state = state == TimetableViewStyle.table
        ? TimetableViewStyle.list
        : TimetableViewStyle.table;
  }
}

enum TimetableViewStyle {
  table(icon: Icon(Icons.table_chart)),
  list(icon: Icon(Icons.list));

  const TimetableViewStyle({required this.icon});

  final Icon icon;
}
