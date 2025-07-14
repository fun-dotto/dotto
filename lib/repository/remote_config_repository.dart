import 'package:flutter/foundation.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../domain/remote_config_keys.dart';

final class RemoteConfigRepository {
  final remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    if (kDebugMode) {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 0),
      ));
    } else {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));
    }

    if (kDebugMode) {
      await remoteConfig.setDefaults(const {
        RemoteConfigKeys.isDesignV2Enabled: false,
        RemoteConfigKeys.isFunchEnabled: true,
        RemoteConfigKeys.isValidAppVersion: true,
        RemoteConfigKeys.userKeySettingUrl: 'https://dotto.web.app/',
      });
    } else {
      await remoteConfig.setDefaults(const {
        RemoteConfigKeys.isDesignV2Enabled: false,
        RemoteConfigKeys.isFunchEnabled: false,
        RemoteConfigKeys.isValidAppVersion: true,
        RemoteConfigKeys.userKeySettingUrl: 'https://dotto.web.app/',
      });
    }

    await remoteConfig.fetchAndActivate();
  }

  bool getBool(String key) {
    return remoteConfig.getBool(key);
  }

  double getDouble(String key) {
    return remoteConfig.getDouble(key);
  }

  int getInt(String key) {
    return remoteConfig.getInt(key);
  }

  String getString(String key) {
    return remoteConfig.getString(key);
  }
}
