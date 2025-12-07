import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class DateFormatter {
  static String full(DateTime dateTime) {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    return DateFormat.yMMMd(
      locale.toString(),
    ).add_jm().format(dateTime.toLocal());
  }

  static String dayOfMonth(DateTime dateTime) {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    return DateFormat.d(locale.toString()).format(dateTime.toLocal());
  }

  static String dayOfWeek(DateTime dateTime) {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    return DateFormat.E(locale.toString()).format(dateTime.toLocal());
  }
}
