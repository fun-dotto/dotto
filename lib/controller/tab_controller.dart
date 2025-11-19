import 'package:dotto/domain/tab_item.dart';
import 'package:dotto/helper/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabItemProvider = NotifierProvider<TabNotifier, TabItem>(TabNotifier.new);

final class TabNotifier extends Notifier<TabItem> {
  @override
  TabItem build() {
    return TabItem.home;
  }

  void selected(TabItem selectedTab) {
    if (state != selectedTab) {
      state = selectedTab;
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
}
