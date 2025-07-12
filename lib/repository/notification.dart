import 'package:dotto/feature/announcement/controller/news_controller.dart';
import 'package:dotto/importer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
    final token = await messaging.getToken();
    if (token != null) {
      debugPrint('FCM Token: $token');
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
    final newsId = message.data['news'];
    if (newsId != null) {
      ref.read(newsFromPushNotificationProvider.notifier).set(newsId as String);
    }
  }
}
