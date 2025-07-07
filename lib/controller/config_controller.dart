import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/remote_config_repository.dart';
import '../domain/remote_config_keys.dart';

class ConfigController extends StateNotifier<ConfigState> {
  final RemoteConfigRepository _remoteConfigRepository;

  ConfigController(this._remoteConfigRepository) : super(const ConfigState());

  Future<void> fetchConfigs() async {
    state = state.copyWith(isLoading: true);

    try {
      final isDesignV2Enabled =
          await _remoteConfigRepository.getBool(RemoteConfigKeys.isDesignV2Enabled);
      final isFunchEnabled = await _remoteConfigRepository.getBool(RemoteConfigKeys.isFunchEnabled);
      final isValidAppVersion =
          await _remoteConfigRepository.getBool(RemoteConfigKeys.isValidAppVersion);

      state = state.copyWith(
        isDesignV2Enabled: isDesignV2Enabled,
        isFunchEnabled: isFunchEnabled,
        isValidAppVersion: isValidAppVersion,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

class ConfigState {
  final bool isDesignV2Enabled;
  final bool isFunchEnabled;
  final bool isValidAppVersion;
  final bool isLoading;
  final String? error;

  const ConfigState({
    this.isDesignV2Enabled = false,
    this.isFunchEnabled = false,
    this.isValidAppVersion = true,
    this.isLoading = false,
    this.error,
  });

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

final configControllerProvider = StateNotifierProvider<ConfigController, ConfigState>((ref) {
  return ConfigController(ref.read(remoteConfigRepositoryProvider));
});
