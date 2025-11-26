import 'package:dotto/feature/announcement/announcement_service.dart';
import 'package:dotto/feature/announcement/announcement_view_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'announcement_viewmodel.g.dart';

@riverpod
final class AnnouncementViewModel extends _$AnnouncementViewModel {
  @override
  Future<AnnouncementViewState> build() async {
    final service = AnnouncementService(ref);
    final announcements = await service.getAnnouncements();
    return AnnouncementViewState(announcements: announcements);
  }
}
