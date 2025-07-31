import 'package:dotto/domain/analytics_event_keys.dart';
import 'package:dotto/domain/analytics_user_property_keys.dart';
import 'package:dotto/repository/firebase_analytics_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsControllerProvider =
    NotifierProvider<AnalyticsController, void>(AnalyticsController.new);

final firebaseAnalyticsRepositoryProvider =
    Provider<FirebaseAnalyticsRepository>(
        (ref) => FirebaseAnalyticsRepository());

final class AnalyticsController extends Notifier<void> {
  @override
  void build() {
    return;
  }

  Future<void> logEvent(
    AnalyticsEventKeys key,
    Map<String, Object> parameters,
  ) async {
    await ref
        .read(firebaseAnalyticsRepositoryProvider)
        .logEvent(key.name, parameters);
  }

  Future<void> setUserId(String userId) async {
    await ref.read(firebaseAnalyticsRepositoryProvider).setUserId(userId);
  }

  Future<void> setUserProperty(
    AnalyticsUserPropertyKeys key,
    String value,
  ) async {
    await ref
        .read(firebaseAnalyticsRepositoryProvider)
        .setUserProperty(key.name, value);
  }

  Future<void> resetAnalyticsData() async {
    await ref.read(firebaseAnalyticsRepositoryProvider).resetAnalyticsData();
  }
}
