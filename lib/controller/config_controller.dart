import 'package:dotto/domain/remote_config_keys.dart';
import 'package:dotto/repository/remote_config_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class ConfigController extends StateNotifier<ConfigState> {
  ConfigController(this._remoteConfigRepository) : super(const ConfigState());
  final RemoteConfigRepository _remoteConfigRepository;

  Future<void> fetchConfigs() async {
    state = state.copyWith(isLoading: true);

    try {
      final isDesignV2Enabled =
          _remoteConfigRepository.getBool(RemoteConfigKeys.isDesignV2Enabled);
      final isFunchEnabled =
          _remoteConfigRepository.getBool(RemoteConfigKeys.isFunchEnabled);
      final isValidAppVersion =
          _remoteConfigRepository.getBool(RemoteConfigKeys.isValidAppVersion);

      state = state.copyWith(
        isDesignV2Enabled: isDesignV2Enabled,
        isFunchEnabled: isFunchEnabled,
        isValidAppVersion: isValidAppVersion,
        isLoading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final class ConfigState {
  const ConfigState({
    this.isDesignV2Enabled = false,
    this.isFunchEnabled = false,
    this.isValidAppVersion = true,
    this.isLoading = false,
    this.error,
  });
  static const String cloudflareR2Endpoint =
      String.fromEnvironment('CLOUDFLARE_R2_ENDPOINT');
  static const String cloudflareR2AccessKeyId =
      String.fromEnvironment('CLOUDFLARE_R2_ACCESS_KEY_ID');
  static const String cloudflareR2SecretAccessKey =
      String.fromEnvironment('CLOUDFLARE_R2_SECRET_ACCESS_KEY');
  static const String cloudflareR2BucketName =
      String.fromEnvironment('CLOUDFLARE_R2_BUCKET_NAME');

  final bool isDesignV2Enabled;
  final bool isFunchEnabled;
  final bool isValidAppVersion;

  final bool isLoading;
  final String? error;

  ConfigState copyWith({
    bool? isDesignV2Enabled,
    bool? isFunchEnabled,
    bool? isValidAppVersion,
    bool? isLoading,
    String? error,
  }) {
    return ConfigState(
      isDesignV2Enabled: isDesignV2Enabled ?? this.isDesignV2Enabled,
      isFunchEnabled: isFunchEnabled ?? this.isFunchEnabled,
      isValidAppVersion: isValidAppVersion ?? this.isValidAppVersion,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final remoteConfigRepositoryProvider = Provider<RemoteConfigRepository>((ref) {
  return RemoteConfigRepository();
});

final configControllerProvider =
    StateNotifierProvider<ConfigController, ConfigState>((ref) {
  return ConfigController(ref.read(remoteConfigRepositoryProvider));
});
