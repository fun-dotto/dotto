import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/controller/tab_controller.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/tab_item.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/bus/controller/bus_data_controller.dart';
import 'package:dotto/feature/bus/controller/bus_polling_controller.dart';
import 'package:dotto/feature/bus/controller/bus_stops_controller.dart';
import 'package:dotto/feature/bus/controller/my_bus_stop_controller.dart';
import 'package:dotto/feature/bus/repository/bus_repository.dart';
import 'package:dotto/feature/setting/repository/settings_repository.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/helper/logger.dart';
import 'package:dotto/helper/notification_repository.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:dotto/theme/v1/theme.dart';
// import 'package:dotto/widget/app_tutorial.dart';
import 'package:dotto/widget/invalid_app_version_screen.dart';
import 'package:dotto_design_system/style/theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher_string.dart';

final class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

final class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    ref.read(loggerProvider).logAppOpen();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dotto',
      theme: config.isDesignV2Enabled ? DottoTheme.v2 : DottoThemev1.theme,
      home: const BasePage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja'), Locale('en')],
      locale: const Locale('ja'),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
    );
  }
}

final class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});

  @override
  ConsumerState<BasePage> createState() => _BasePageState();
}

final class _BasePageState extends ConsumerState<BasePage> {
  late List<String?> parameter;
  // bool _hasShownDialogs = false;

  Future<void> setupUniversalLinks() async {
    final appLinks = AppLinks();
    appLinks.uriLinkStream
        .listen((event) {
          if (event.path == '/config/' && event.hasQuery) {
            final query = event.queryParameters;
            if (query.containsKey('userkey')) {
              final userKey = query['userkey'];
              if (userKey != null) {
                SettingsRepository().setUserKey(userKey, ref);
              }
            }
          }
        })
        .onError((Object error, StackTrace stackTrace) {
          debugPrint(error.toString());
        });
  }

  Future<void> getPersonalLessonIdList() async {
    await TimetableRepository().loadPersonalTimetableList(ref);
  }

  Future<void> getBus() async {
    await ref.read(busStopsNotifierProvider.notifier).build();
    await ref.read(busDataNotifierProvider.notifier).build();
    await ref.read(myBusStopNotifierProvider.notifier).load();
    ref.read(busPollingNotifierProvider.notifier).start();
    await BusRepository().changeDirectionOnCurrentLocation(ref);
  }

  Future<void> _saveFCMToken() async {
    final didSave =
        await UserPreferenceRepository.getBool(
          UserPreferenceKeys.didSaveFCMToken,
        ) ??
        false;
    if (didSave) {
      return;
    }
    final user = ref.read(userProvider);
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    debugPrint('APNs Token: $apnsToken');
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $fcmToken');
    if (fcmToken != null && user != null) {
      final db = FirebaseFirestore.instance;
      final tokenRef = db.collection('fcm_token');
      final tokenQuery = tokenRef
          .where('uid', isEqualTo: user.uid)
          .where('token', isEqualTo: fcmToken);
      final tokenQuerySnapshot = await tokenQuery.get();
      final tokenDocs = tokenQuerySnapshot.docs;
      if (tokenDocs.isEmpty) {
        await tokenRef.add({
          'uid': user.uid,
          'token': fcmToken,
          'last_updated': Timestamp.now(),
        });
      }
      await UserPreferenceRepository.setBool(
        UserPreferenceKeys.didSaveFCMToken,
        value: true,
      );
    }
  }

  Future<void> init() async {
    await _saveFCMToken();
    await LoggerImpl().setup();
    await NotificationRepository().setupInteractedMessage(ref);
    await setupUniversalLinks();
    await getPersonalLessonIdList();
    await getBus();
  }

  @override
  void initState() {
    super.initState();
    unawaited(init());
  }

  Future<void> _onItemTapped(int index) async {
    final selectedTab = TabItem.values[index];
    ref.read(tabItemProvider.notifier).selected(selectedTab);
  }

  // Future<void> _showAppTutorial(BuildContext context) async {
  //   if (await UserPreferenceRepository.getBool(
  //         UserPreferenceKeys.isAppTutorialComplete,
  //       ) ??
  //       false) {
  //     return;
  //   }
  //   if (context.mounted) {
  //     await Navigator.of(context).push(
  //       MaterialPageRoute<void>(
  //         builder: (_) => const AppTutorial(),
  //         settings: const RouteSettings(name: '/app_tutorial'),
  //       ),
  //     );
  //     await UserPreferenceRepository.setBool(
  //       UserPreferenceKeys.isAppTutorialComplete,
  //       value: true,
  //     );
  //   }
  // }

  // Future<void> _showInvalidAppVersionDialog(
  //   BuildContext context,
  //   String appStorePageUrl,
  // ) async {
  //   await showDialog<void>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('アップデートが必要です'),
  //       content: const Text('最新版のDottoをご利用ください。'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('あとで'),
  //         ),
  //         TextButton(
  //           onPressed: () => launchUrlString(
  //             appStorePageUrl,
  //             mode: LaunchMode.externalApplication,
  //           ),
  //           child: const Text('今すぐアップデート'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configNotifierProvider);
    if (!config.isValidAppVersion) {
      debugPrint('Invalid App Version');
      return InvalidAppVersionScreen(appStorePageUrl: config.appStorePageUrl);
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!_hasShownDialogs && !config.isLatestAppVersion) {
    //     debugPrint('Not Latest App Version');
    //     _showInvalidAppVersionDialog(context, config.appStorePageUrl);
    //     _hasShownDialogs = true;
    //   }
    //   _showAppTutorial(context);
    // });
    final tabItem = ref.watch(tabItemProvider);
    return PopScope(
      canPop: Platform.isIOS,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        final shouldPop =
            !((await tabNavigatorKeyMaps[tabItem]?.currentState?.maybePop()) ??
                true);
        if (shouldPop && navigator.canPop()) navigator.pop();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: TabItem.values
                .map(
                  (tabItemOnce) => Offstage(
                    offstage: tabItem != tabItemOnce,
                    child: Navigator(
                      key: tabNavigatorKeyMaps[tabItemOnce],
                      onGenerateRoute: (settings) {
                        return MaterialPageRoute(
                          builder: (context) => tabItemOnce.page,
                        );
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: TabItem.values.indexOf(tabItem),
          items: TabItem.values
              .map(
                (tabItem) => BottomNavigationBarItem(
                  icon: Icon(tabItem.icon),
                  activeIcon: Icon(tabItem.activeIcon),
                  label: tabItem.title,
                ),
              )
              .toList(),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
