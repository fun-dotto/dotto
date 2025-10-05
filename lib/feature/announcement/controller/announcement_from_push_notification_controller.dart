import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'announcement_from_push_notification_controller.g.dart';

@riverpod
final class AnnouncementFromPushNotificationNotifier
    extends _$AnnouncementFromPushNotificationNotifier {
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
