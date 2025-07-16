import 'package:flutter_riverpod/flutter_riverpod.dart';

final announcementFromPushNotificationProvider =
    NotifierProvider<AnnouncementFromPushNotificationNotifier, Uri?>(
        AnnouncementFromPushNotificationNotifier.new);

final class AnnouncementFromPushNotificationNotifier extends Notifier<Uri?> {
  @override
  Uri? build() {
    return null;
  }

  Uri? get url => state;

  set url(Uri? value) {
    state = value;
  }

  void reset() {
    state = null;
  }
}
