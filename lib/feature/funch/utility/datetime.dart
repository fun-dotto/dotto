import 'package:intl/intl.dart';

final class DateTimeUtility {
  /// Returns the first day of the month for the given date.
  static DateTime firstDateOfMonth(DateTime datetime) {
    return DateTime(datetime.year, datetime.month);
  }

  /// Returns the start of the day (00:00:00) for the given date.
  static DateTime startOfDay(DateTime datetime) {
    return DateTime(datetime.year, datetime.month, datetime.day);
  }

  static final DateFormat dateKeyFormatter = DateFormat('yyyy-MM-dd');

  static String dateKey(DateTime datetime) {
    return dateKeyFormatter.format(datetime);
  }

  static DateTime parseDateKey(String dateKey) {
    return DateTime.parse(dateKey);
  }
}
