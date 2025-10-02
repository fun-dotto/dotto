import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/feature/announcement/domain/announcement.dart';
import 'package:dotto/feature/announcement/repository/announcement_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final announcementsControllerProvider =
    AsyncNotifierProvider<AnnouncementsController, List<Announcement>>(
      AnnouncementsController.new,
    );

final announcementRepositoryProvider = Provider<AnnouncementRepository>(
  (ref) => AnnouncementRepositoryImpl(),
);

final class AnnouncementsController extends AsyncNotifier<List<Announcement>> {
  @override
  Future<List<Announcement>> build() async {
    try {
      final announcementRepository = ref.read(announcementRepositoryProvider);
      final config = ref.read(configNotifierProvider);
      final url = Uri.parse(config.announcementsUrl);
      final announcements = await announcementRepository.getAnnouncements(url);
      return announcements.where((e) => e.isActive).toList()
        ..sort((lhs, rhs) => rhs.date.compareTo(lhs.date));
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
