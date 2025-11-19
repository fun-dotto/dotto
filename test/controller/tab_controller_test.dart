import 'package:dotto/controller/tab_controller.dart';
import 'package:dotto/domain/tab_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

final tabItemProvider = NotifierProvider<TabNotifier, TabItem>(() {
  return TabNotifier();
});

final class Listener extends Mock {
  void call(TabItem? previous, TabItem value);
}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });
  tearDown(() {
    container.dispose();
  });

  test('defaults to `home` and notify listeners when value changes', () async {
    final listener = Listener();

    container.listen<TabItem>(
      tabItemProvider,
      listener.call,
      fireImmediately: true,
    );

    verify(listener(null, TabItem.home)).called(1);
    verifyNoMoreInteractions(listener);

    container.read(tabItemProvider.notifier).selected(TabItem.map);

    verify(listener(TabItem.home, TabItem.map)).called(1);
    verifyNoMoreInteractions(listener);

    container.read(tabItemProvider.notifier).selected(TabItem.course);

    verify(listener(TabItem.map, TabItem.course)).called(1);
    verifyNoMoreInteractions(listener);

    container.read(tabItemProvider.notifier).selected(TabItem.assignment);

    verify(listener(TabItem.course, TabItem.assignment)).called(1);
    verifyNoMoreInteractions(listener);

    container.read(tabItemProvider.notifier).selected(TabItem.setting);

    verify(listener(TabItem.assignment, TabItem.setting)).called(1);
    verifyNoMoreInteractions(listener);

    container.read(tabItemProvider.notifier).selected(TabItem.home);

    verify(listener(TabItem.setting, TabItem.home)).called(1);
    verifyNoMoreInteractions(listener);
  });
}
