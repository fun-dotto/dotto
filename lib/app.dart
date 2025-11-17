import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/controller/analytics_controller.dart';
import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/controller/tab_controller.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/tab_item.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/announcement/controller/announcement_from_push_notification_controller.dart';
import 'package:dotto/feature/bus/controller/bus_data_controller.dart';
import 'package:dotto/feature/bus/controller/bus_polling_controller.dart';
import 'package:dotto/feature/bus/controller/bus_stops_controller.dart';
import 'package:dotto/feature/bus/controller/my_bus_stop_controller.dart';
import 'package:dotto/feature/bus/repository/bus_repository.dart';
import 'package:dotto/feature/setting/repository/settings_repository.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/helper/notification_repository.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:dotto/theme/v1/animation.dart';
import 'package:dotto/theme/v1/theme.dart';
import 'package:dotto/widget/app_tutorial.dart';
import 'package:dotto_design_system/style/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

final class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
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

  Future<void> _setupAnalytics() async {
    final user = ref.read(userProvider);
    if (user != null) {
      await ref.read(analyticsControllerProvider.notifier).setUserId(user.uid);
    }
  }

  Future<void> init() async {
    await _saveFCMToken();
    await _setupAnalytics();
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
    ref.read(announcementFromPushNotificationNotifierProvider.notifier).reset();
    final selectedTab = TabItem.values[index];
    ref.read(tabItemProvider.notifier).selected(selectedTab);
  }

  Future<void> _showAppTutorial(BuildContext context) async {
    if (await UserPreferenceRepository.getBool(
          UserPreferenceKeys.isAppTutorialComplete,
        ) ??
        false) {
      return;
    }
    if (context.mounted) {
      await Navigator.of(context).push(
        PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AppTutorial(),
          fullscreenDialog: true,
          transitionsBuilder: fromRightAnimation,
        ),
      );
      await UserPreferenceRepository.setBool(
        UserPreferenceKeys.isAppTutorialComplete,
        value: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showAppTutorial(context),
    );
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
