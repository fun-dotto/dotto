import 'package:dotto/domain/config.dart';
import 'package:dotto/domain/remote_config_keys.dart';
import 'package:dotto/repository/remote_config_repository.dart';
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
    final userKeySettingUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.userKeySettingUrl,
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

    return Config(
      isDesignV2Enabled: isDesignV2Enabled,
      isFunchEnabled: isFunchEnabled,
      isValidAppVersion: isValidAppVersion,
      userKeySettingUrl: userKeySettingUrl,
      announcementsUrl: announcementsUrl,
      assignmentSetupUrl: assignmentSetupUrl,
      feedbackFormUrl: feedbackFormUrl,
    );
  }

  void refresh() {
    state = build();
  }
}
