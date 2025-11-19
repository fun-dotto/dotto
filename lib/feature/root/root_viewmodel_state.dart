import 'package:dotto/domain/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'root_viewmodel_state.freezed.dart';

@freezed
abstract class RootViewModelState with _$RootViewModelState {
  const factory RootViewModelState({
    required TabItem selectedTab,
    required Map<TabItem, GlobalKey<NavigatorState>> navigatorStates,
  }) = _RootViewModelState;
}
