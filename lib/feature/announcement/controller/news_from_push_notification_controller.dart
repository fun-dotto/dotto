import 'package:flutter_riverpod/flutter_riverpod.dart';

final newsFromPushNotificationProvider =
    NotifierProvider<NewsFromPushNotificationNotifier, String?>(
        NewsFromPushNotificationNotifier.new);

final class NewsFromPushNotificationNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  String? get newsId => state;

  set newsId(String? value) {
    state = value;
  }

  void reset() {
    state = null;
  }
}
