import 'package:dotto/domain/announcement.dart';
import 'package:dotto/repository/announcement_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'announcement_viewmodel.g.dart';

@riverpod
final class AnnouncementViewModel extends _$AnnouncementViewModel {
  @override
  Future<List<Announcement>> build() async {
    try {
      final announcementRepository = ref.read(announcementRepositoryProvider);
      return await announcementRepository.getAnnouncements();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
