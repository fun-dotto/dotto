import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../domain/remote_config_keys.dart';

final class RemoteConfigRepository {
  final remoteConfig = FirebaseRemoteConfig.instance;

  RemoteConfigRepository() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (const bool.fromEnvironment('dart.vm.product') == false) {
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

    await remoteConfig.setDefaults(const {
      RemoteConfigKeys.isDesignV2Enabled: false,
      RemoteConfigKeys.isFunchEnabled: false,
      RemoteConfigKeys.isValidAppVersion: true,
    });
  }

  Future<bool> getBool(String key) async {
    await remoteConfig.fetchAndActivate();
    return remoteConfig.getBool(key);
  }

  Future<double> getDouble(String key) async {
    await remoteConfig.fetchAndActivate();
    return remoteConfig.getDouble(key);
  }

  Future<int> getInt(String key) async {
    await remoteConfig.fetchAndActivate();
    return remoteConfig.getInt(key);
  }

  Future<String> getString(String key) async {
    await remoteConfig.fetchAndActivate();
    return remoteConfig.getString(key);
  }
}
