import 'package:dotto/domain/tab_item.dart';
import 'package:dotto/feature/root/root_viewmodel_state.dart';
import 'package:dotto/helper/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root_viewmodel.g.dart';

@riverpod
class RootViewModel extends _$RootViewModel {
  @override
  RootViewModelState build() {
    return const RootViewModelState(selectedTab: TabItem.home);
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
    final navigatorKey = tabNavigatorKeyMaps[selectedTab];
    if (navigatorKey == null) {
      return;
    }
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      return;
    }
    currentState.popUntil((route) => route.isFirst);

    ref.read(loggerProvider).logChangedTab(tabItem: selectedTab);
  }

  void onGoToSettingButtonTapped() {
    state = state.copyWith(selectedTab: TabItem.setting);
  }
}
