import 'package:dotto/domain/config.dart';
import 'package:dotto/domain/remote_config_keys.dart';
import 'package:dotto/repository/remote_config_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final configControllerProvider =
    NotifierProvider<ConfigController, Config>(ConfigController.new);

final remoteConfigRepositoryProvider =
    Provider<RemoteConfigRepository>((ref) => RemoteConfigRepository());

final class ConfigController extends Notifier<Config> {
  @override
  Config build() {
    final remoteConfigRepository = ref.read(remoteConfigRepositoryProvider);

    final isDesignV2Enabled =
        remoteConfigRepository.getBool(RemoteConfigKeys.isDesignV2Enabled);
    final isFunchEnabled =
        remoteConfigRepository.getBool(RemoteConfigKeys.isFunchEnabled);
    final isValidAppVersion =
        remoteConfigRepository.getBool(RemoteConfigKeys.isValidAppVersion);
    final announcementsUrl =
        remoteConfigRepository.getString(RemoteConfigKeys.announcementsUrl);
    final assignmentSetupUrl =
        remoteConfigRepository.getString(RemoteConfigKeys.assignmentSetupUrl);
    final feedbackFormUrl =
        remoteConfigRepository.getString(RemoteConfigKeys.feedbackFormUrl);

    return Config(
      isDesignV2Enabled: isDesignV2Enabled,
      isFunchEnabled: isFunchEnabled,
      isValidAppVersion: isValidAppVersion,
      announcementsUrl: announcementsUrl,
      assignmentSetupUrl: assignmentSetupUrl,
      feedbackFormUrl: feedbackFormUrl,
    );
  }
}
