import 'dart:async';

import 'package:dotto/feature/debug/debug_view_model_state.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_view_model.g.dart';

@riverpod
class DebugViewModel extends _$DebugViewModel {
  @override
  Future<DebugViewModelState> build() async {
    final appCheckAccessToken = await FirebaseAppCheck.instance.getToken();
    final state = DebugViewModelState(
      appCheckAccessToken: appCheckAccessToken ?? '',
    );
    return state;
  }
}
