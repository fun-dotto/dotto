import 'package:dotto/domain/config.dart';
import 'package:dotto/domain/remote_config_keys.dart';
import 'package:dotto/helper/remote_config_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'config_controller.g.dart';

final remoteConfigRepositoryProvider = Provider<RemoteConfigRepository>(
  (ref) => RemoteConfigRepository(),
);

@riverpod
final class ConfigNotifier extends _$ConfigNotifier {
  @override
  Config build() {
    final remoteConfigRepository = ref.read(remoteConfigRepositoryProvider);

    final isDesignV2Enabled = remoteConfigRepository.getBool(
      RemoteConfigKeys.isDesignV2Enabled,
    );
    final isFunchEnabled = remoteConfigRepository.getBool(
      RemoteConfigKeys.isFunchEnabled,
    );
    final isValidAppVersion = remoteConfigRepository.getBool(
      RemoteConfigKeys.isValidAppVersion,
    );
    final isLatestAppVersion = remoteConfigRepository.getBool(
      RemoteConfigKeys.isLatestAppVersion,
    );
    final announcementsUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.announcementsUrl,
    );
    final assignmentSetupUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.assignmentSetupUrl,
    );
    final feedbackFormUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.feedbackFormUrl,
    );
    final termsOfServiceUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.termsOfServiceUrl,
    );
    final privacyPolicyUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.privacyPolicyUrl,
    );
    final appStorePageUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.appStorePageUrl,
    );
    final officialCalendarPdfUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.officialCalendarPdfUrl,
    );
    final timetable1PdfUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.timetable1PdfUrl,
    );
    final timetable2PdfUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.timetable2PdfUrl,
    );

    return Config(
      isDesignV2Enabled: isDesignV2Enabled,
      isFunchEnabled: isFunchEnabled,
      isValidAppVersion: isValidAppVersion,
      isLatestAppVersion: isLatestAppVersion,
      announcementsUrl: announcementsUrl,
      assignmentSetupUrl: assignmentSetupUrl,
      feedbackFormUrl: feedbackFormUrl,
      termsOfServiceUrl: termsOfServiceUrl,
      privacyPolicyUrl: privacyPolicyUrl,
      appStorePageUrl: appStorePageUrl,
      officialCalendarPdfUrl: officialCalendarPdfUrl,
      timetable1PdfUrl: timetable1PdfUrl,
      timetable2PdfUrl: timetable2PdfUrl,
    );
  }

  void refresh() {
    state = build();
  }
}
