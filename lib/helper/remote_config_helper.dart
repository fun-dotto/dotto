import 'package:dotto/domain/remote_config_keys.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteConfigHelperProvider = Provider<RemoteConfigHelper>(
  (ref) => _RemoteConfigHelperImpl(),
);

abstract class RemoteConfigHelper {
  Future<void> setup();
  bool getBool(String key);
  double getDouble(String key);
  int getInt(String key);
  String getString(String key);
}

final class _RemoteConfigHelperImpl implements RemoteConfigHelper {
  @override
  Future<void> setup() async {
    if (kDebugMode) {
      await FirebaseRemoteConfig.instance.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: Duration.zero,
        ),
      );
    } else {
      await FirebaseRemoteConfig.instance.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
    }

    if (kDebugMode) {
      await FirebaseRemoteConfig.instance.setDefaults(const {
        RemoteConfigKeys.isDesignV2Enabled: false,
        RemoteConfigKeys.isFunchEnabled: true,
        RemoteConfigKeys.isValidAppVersion: true,
        RemoteConfigKeys.isLatestAppVersion: true,
        RemoteConfigKeys.announcementsUrl:
            'https://fun-dotto.github.io/data/announcements.json',
        RemoteConfigKeys.assignmentSetupUrl: 'https://dotto.web.app/',
        RemoteConfigKeys.feedbackFormUrl: 'https://forms.gle/ruo8iBxLMmvScNMFA',
        RemoteConfigKeys.appStorePageUrl: 'https://fun-dotto.github.io',
        RemoteConfigKeys.officialCalendarPdfUrl:
            'https://fun-dotto.github.io/files/official_calendar_2025.pdf',
        RemoteConfigKeys.timetable1PdfUrl:
            'https://fun-dotto.github.io/files/timetable_2025_1.pdf',
        RemoteConfigKeys.timetable2PdfUrl:
            'https://fun-dotto.github.io/files/timetable_2025_2.pdf',
      });
    } else {
      await FirebaseRemoteConfig.instance.setDefaults(const {
        RemoteConfigKeys.isDesignV2Enabled: false,
        RemoteConfigKeys.isFunchEnabled: false,
        RemoteConfigKeys.isValidAppVersion: true,
        RemoteConfigKeys.isLatestAppVersion: true,
        RemoteConfigKeys.announcementsUrl:
            'https://fun-dotto.github.io/data/announcements.json',
        RemoteConfigKeys.assignmentSetupUrl: 'https://dotto.web.app/',
        RemoteConfigKeys.feedbackFormUrl: 'https://forms.gle/ruo8iBxLMmvScNMFA',
        RemoteConfigKeys.appStorePageUrl: 'https://fun-dotto.github.io',
        RemoteConfigKeys.officialCalendarPdfUrl:
            'https://fun-dotto.github.io/files/official_calendar_2025.pdf',
        RemoteConfigKeys.timetable1PdfUrl:
            'https://fun-dotto.github.io/files/timetable_2025_1.pdf',
        RemoteConfigKeys.timetable2PdfUrl:
            'https://fun-dotto.github.io/files/timetable_2025_2.pdf',
      });
    }

    await FirebaseRemoteConfig.instance.fetchAndActivate();
  }

  @override
  bool getBool(String key) {
    return FirebaseRemoteConfig.instance.getBool(key);
  }

  @override
  double getDouble(String key) {
    return FirebaseRemoteConfig.instance.getDouble(key);
  }

  @override
  int getInt(String key) {
    return FirebaseRemoteConfig.instance.getInt(key);
  }

  @override
  String getString(String key) {
    return FirebaseRemoteConfig.instance.getString(key);
  }
}
