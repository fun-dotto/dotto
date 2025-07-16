import 'package:dotto/domain/tab_item.dart';
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
    final navigatorKey = tabNavigatorKeyMaps[selectedTab];
    if (navigatorKey != null) {
      final currentState = navigatorKey.currentState;
      if (currentState != null) {
        currentState.popUntil((route) => route.isFirst);
      }
    }
  }
}
