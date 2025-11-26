import 'package:dotto/domain/announcement.dart';
import 'package:dotto/repository/announcement_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class AnnouncementService {
  AnnouncementService({required this.ref});

  final Ref ref;

  Future<List<Announcement>> getAnnouncements() async {
    return ref.read(announcementRepositoryProvider).getAnnouncements();
  }
}
