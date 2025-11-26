import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/feature/announcement/domain/announcement.dart';
import 'package:dotto/feature/announcement/repository/announcement_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'announcements_controller.g.dart';

@riverpod
final class AnnouncementsNotifier extends _$AnnouncementsNotifier {
  @override
  Future<List<Announcement>> build() async {
    try {
      final announcementRepository = ref.read(announcementRepositoryProvider);
      final config = ref.read(configProvider);
      final url = Uri.parse(config.announcementsUrl);
      return await announcementRepository.getAnnouncements(url);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
