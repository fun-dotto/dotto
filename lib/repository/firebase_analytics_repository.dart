import 'package:firebase_analytics/firebase_analytics.dart';

final class FirebaseAnalyticsRepository {
  FirebaseAnalyticsRepository();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent(String name, Map<String, Object> parameters) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  Future<void> resetAnalyticsData() async {
    await _analytics.resetAnalyticsData();
  }
}
