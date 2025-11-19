import 'package:dotto/domain/remote_config_keys.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

final class RemoteConfigRepository {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    if (kDebugMode) {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: Duration.zero,
        ),
      );
    } else {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
    }

    if (kDebugMode) {
      await remoteConfig.setDefaults(const {
        RemoteConfigKeys.isDesignV2Enabled: false,
        RemoteConfigKeys.isFunchEnabled: true,
        RemoteConfigKeys.isValidAppVersion: true,
        RemoteConfigKeys.isLatestAppVersion: true,
        RemoteConfigKeys.announcementsUrl:
            'https://fun-dotto.github.io/data/announcements.json',
        RemoteConfigKeys.assignmentSetupUrl: 'https://dotto.web.app/',
        RemoteConfigKeys.feedbackFormUrl: 'https://forms.gle/ruo8iBxLMmvScNMFA',
        RemoteConfigKeys.appStorePageUrl: 'https://fun-dotto.github.io',
      });
    } else {
      await remoteConfig.setDefaults(const {
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
