import 'dart:async';

import 'package:dotto/app.dart';
import 'package:dotto/firebase_options.dart';
import 'package:dotto/repository/firebase_storage_repository.dart';
import 'package:dotto/repository/location_repository.dart';
import 'package:dotto/repository/remote_config_repository.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebaseの初期化
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firebase Crashlyticsの初期化
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Firebase App Checkの初期化
  await FirebaseAppCheck.instance.activate(
    androidProvider: kReleaseMode
        ? AndroidProvider.playIntegrity
        : AndroidProvider.debug,
    appleProvider: kReleaseMode ? AppleProvider.appAttest : AppleProvider.debug,
  );

  // Firebase Remote Configの初期化
  await RemoteConfigRepository.initialize();

  // Firebase Realtime Databaseのパーシステンスを有効化
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  // 画面の向きを固定
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ローカルタイムゾーンの設定
  await _configureLocalTimeZone();

  // Firebase Messagingの通知許可をリクエスト
  await FirebaseMessaging.instance.requestPermission();

  // Firebase Messagingのバックグラウンドハンドラーを設定
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 位置情報の許可をリクエスト
  await LocationRepository().requestLocationPermission();

  // ファイルをダウンロード
  await _downloadFiles();

  // アプリの起動
  runApp(const ProviderScope(child: MyApp()));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));
}

Future<void> _downloadFiles() async {
  try {
    await Future(() {
      // Firebaseからファイルをダウンロード
      final filePaths = <String>[
        'map/oneweek_schedule.json',
        'home/cancel_lecture.json',
        'home/sup_lecture.json',
        'funch/menu.json',
      ];
      for (final path in filePaths) {
        FirebaseStorageRepository().download(path);
      }
    });
  } on Exception catch (e) {
    debugPrint(e.toString());
  }
}
