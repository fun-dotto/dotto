import 'package:dotto/domain/tab_item.dart';
import 'package:dotto/feature/root/root_viewmodel_state.dart';
import 'package:dotto/helper/logger.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root_viewmodel.g.dart';

@riverpod
class RootViewModel extends _$RootViewModel {
  @override
  RootViewModelState build() {
    return RootViewModelState(
      selectedTab: TabItem.home,
      navigatorStates: {
        for (final tabItem in TabItem.values)
          tabItem: GlobalKey<NavigatorState>(),
      },
    );
  }

  void onTabItemTapped(int index) {
    final selectedTab = TabItem.values.elementAtOrNull(index);
    if (selectedTab == null) {
      return;
    }
    if (state.selectedTab != selectedTab) {
      state = state.copyWith(selectedTab: selectedTab);
      return;
    }
    // 同じタブを押すとルートまでPop
    final navigatorKey = state.navigatorStates[selectedTab];
    if (navigatorKey == null) {
      return;
    }
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      return;
    }
    currentState.popUntil((Route<dynamic> route) => route.isFirst);

    ref.read(loggerProvider).logChangedTab(tabItem: selectedTab);
  }

  void onGoToSettingButtonTapped() {
    state = state.copyWith(selectedTab: TabItem.setting);
  }
}
