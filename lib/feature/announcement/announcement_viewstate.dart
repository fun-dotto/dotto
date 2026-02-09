import 'package:dotto/domain/announcement.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_viewstate.freezed.dart';

@freezed
abstract class AnnouncementViewState with _$AnnouncementViewState {
  const factory AnnouncementViewState({required List<Announcement> announcements}) = _AnnouncementViewState;
}
