import 'package:dotto/feature/timetable/domain/timetable_period_style.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loggerProvider = Provider<Logger>((ref) => LoggerImpl());

abstract class Logger {
  Future<void> setup();
  Future<void> logAppOpen();
  Future<void> logLogin();
  Future<void> logBuiltTimetableSetting({
    required TimetablePeriodStyle timetablePeriodStyle,
  });
  Future<void> logSetTimetableSetting({
    required TimetablePeriodStyle timetablePeriodStyle,
  });
}

final class LoggerImpl implements Logger {
  factory LoggerImpl() {
    return _instance;
  }
  LoggerImpl._internal();
  static final LoggerImpl _instance = LoggerImpl._internal();

  @override
  Future<void> setup() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseAnalytics.instance.setUserId(id: userId);
    }
    debugPrint('[Logger] setup');
    debugPrint('User ID: $userId');
  }

  @override
  Future<void> logAppOpen() async {
    await FirebaseAnalytics.instance.logAppOpen();
    debugPrint('[Logger] app_open');
  }

  @override
  Future<void> logLogin() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    await FirebaseAnalytics.instance.setUserId(id: userId);
    await FirebaseAnalytics.instance.logLogin();
    debugPrint('[Logger] login');
    debugPrint('User ID: $userId');
  }

  @override
  Future<void> logBuiltTimetableSetting({
    required TimetablePeriodStyle timetablePeriodStyle,
  }) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'built_timetable_setting',
      parameters: {'timetable_period_style': timetablePeriodStyle.key},
    );
    debugPrint('[Logger] built_timetable_setting');
    debugPrint('timetable_period_style: ${timetablePeriodStyle.key}');
  }

  @override
  Future<void> logSetTimetableSetting({
    required TimetablePeriodStyle timetablePeriodStyle,
  }) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'set_timetable_setting',
      parameters: {'timetable_period_style': timetablePeriodStyle.key},
    );
    debugPrint('[Logger] set_timetable_setting');
    debugPrint('timetable_period_style: ${timetablePeriodStyle.key}');
  }
}
