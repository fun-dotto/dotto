import 'package:intl/intl.dart';

final class AssignmentDateFormatter {
  AssignmentDateFormatter._();

  static String string(DateTime dateTime) {
    return DateFormat.yMEd('ja').add_Hm().format(dateTime);
  }
}
