import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/setting/controller/settings_controller.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/repository/firebase_auth_repository.dart';
import 'package:dotto/repository/user_preference_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SettingsRepository {
  factory SettingsRepository() {
    return _instance;
  }
  SettingsRepository._internal();
  static final SettingsRepository _instance = SettingsRepository._internal();

  Future<void> setUserKey(String userKey, WidgetRef ref) async {
    final userKeyPattern = RegExp(r'^[a-zA-Z0-9]{16}$');
    if (userKey.length == 16 && userKeyPattern.hasMatch(userKey)) {
      await UserPreferenceRepository.setString(
        UserPreferenceKeys.userKey,
        userKey,
      );
      ref.invalidate(settingsUserKeyProvider);
      return;
    }
    if (userKey.isEmpty) {
      await UserPreferenceRepository.setString(
        UserPreferenceKeys.userKey,
        userKey,
      );
      ref.invalidate(settingsUserKeyProvider);
    }
  }

  Future<void> saveFCMToken(User user) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) {
      return;
    }
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

  Future<void> onLogin(
    BuildContext context,
    void Function(User?) login,
    WidgetRef ref,
  ) async {
    final user = await FirebaseAuthRepository().signIn();
    if (user != null) {
      login(user);
      await saveFCMToken(user);
      if (context.mounted) {
        await TimetableRepository().loadPersonalTimeTableListOnLogin(
          context,
          ref,
        );
      }
      return;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ログインできませんでした。')));
    }
  }

  Future<void> onLogout(void Function() logout) async {
    await FirebaseAuthRepository().signOut();
    logout();
  }
}
