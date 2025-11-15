import 'package:dotto/feature/announcement/controller/announcement_from_push_notification_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class NotificationRepository {
  factory NotificationRepository() {
    return _instance;
  }
  NotificationRepository._internal();
  static final NotificationRepository _instance =
      NotificationRepository._internal();

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

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
      ref.read(announcementFromPushNotificationNotifierProvider.notifier).url =
          Uri.parse(announcementUrl as String);
    }
  }
}
