import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loggerProvider = Provider<Logger>((ref) => LoggerImpl());

abstract class Logger {
  Future<void> setup();
  Future<void> logLogin();
  Future<void> logBuiltTimetableSetting({required bool isNumberOnly});
  Future<void> logSetTimetableSetting({required bool isNumberOnly});
}

final class LoggerImpl implements Logger {
  factory LoggerImpl() {
    return _instance;
  }
  LoggerImpl._internal();
  static final LoggerImpl _instance = LoggerImpl._internal();

  Future<void> setup() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseAnalytics.instance.setUserId(id: userId);
    }
  }

  Future<void> logLogin() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    await FirebaseAnalytics.instance.setUserId(id: userId);
    await FirebaseAnalytics.instance.logLogin();
  }

  Future<void> logBuiltTimetableSetting({required bool isNumberOnly}) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'built_timetable_setting',
      parameters: {'is_number_only': isNumberOnly},
    );
  }

  Future<void> logSetTimetableSetting({required bool isNumberOnly}) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'set_timetable_setting',
      parameters: {'is_number_only': isNumberOnly},
    );
  }
}
