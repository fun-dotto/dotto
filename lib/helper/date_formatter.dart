import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class DateFormatter {
  static String full(DateTime dateTime) {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    return DateFormat.yMMMd(locale.toString()).add_jm().format(dateTime.toLocal());
  }

  static String dayOfMonth(DateTime dateTime) {
    // d(locale.toString())で日本環境になるとd日という表記になるため、localeを指定しない
    return DateFormat.d().format(dateTime.toLocal());
  }

  static String dayOfWeek(DateTime dateTime) {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    return DateFormat.E(locale.toString()).format(dateTime.toLocal());
  }
}
