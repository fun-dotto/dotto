import 'package:dotto/domain/analytics_event_keys.dart';
import 'package:dotto/domain/analytics_user_property_keys.dart';
import 'package:dotto/repository/firebase_analytics_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsControllerProvider = NotifierProvider<AnalyticsController, void>(
  AnalyticsController.new,
);

final firebaseAnalyticsRepositoryProvider =
    Provider<FirebaseAnalyticsRepository>(
      (ref) => FirebaseAnalyticsRepository(),
    );

final class AnalyticsController extends Notifier<void> {
  @override
  void build() {
    return;
  }

  Future<void> logEvent({
    required AnalyticsEventKeys key,
    Map<String, Object>? parameters,
  }) async {
    await ref
        .read(firebaseAnalyticsRepositoryProvider)
        .logEvent(name: key.name, parameters: parameters);
    debugPrint('[Google Analytics] Log event: ${key.name}, $parameters');
  }

  Future<void> setUserId(String userId) async {
    await ref.read(firebaseAnalyticsRepositoryProvider).setUserId(userId);
    debugPrint('[Google Analytics] Set user ID: $userId');
  }

  Future<void> setUserProperty({
    required AnalyticsUserPropertyKeys key,
    required String value,
  }) async {
    await ref
        .read(firebaseAnalyticsRepositoryProvider)
        .setUserProperty(key.name, value);
    debugPrint('[Google Analytics] Set user property: ${key.key} = $value');
  }

  Future<void> resetAnalyticsData() async {
    await ref.read(firebaseAnalyticsRepositoryProvider).resetAnalyticsData();
    debugPrint('[Google Analytics] Reset analytics data');
  }
}
