import 'package:firebase_remote_config/firebase_remote_config.dart';

final class RemoteConfigRepository {
  final remoteConfig = FirebaseRemoteConfig.instance;

  RemoteConfigRepository() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 5),
      ));
    } else {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));
    }

    await remoteConfig.setDefaults(const {
      "is_design_v2_enabled": false,
      "is_funch_enabled": false,
      "is_valid_app_version": true,
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
