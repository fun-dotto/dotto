import 'package:dotto/feature/announcement/controller/announcement_from_push_notification_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class NotificationRepository {
  factory NotificationRepository() {
    return _instance;
  }
  NotificationRepository._internal();
  static final NotificationRepository _instance =
      NotificationRepository._internal();

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await messaging.requestPermission();
    try {
      final token = await messaging.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
      }
    } on FirebaseException catch (error) {
      if (error.code == 'apns-token-not-set') {
        debugPrint(
          'Skipping FCM token fetch: APNS token not available yet on this device.',
        );
        return;
      }
      rethrow;
    }
  }

  Future<void> setupInteractedMessage(WidgetRef ref) async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage, ref);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _handleMessage(message, ref),
    );
  }

  void _handleMessage(RemoteMessage message, WidgetRef ref) {
    final announcementUrl = message.data['announcement_url'];
    if (announcementUrl != null) {
      ref.read(announcementFromPushNotificationProvider.notifier).url =
          Uri.parse(announcementUrl as String);
    }
  }
}
