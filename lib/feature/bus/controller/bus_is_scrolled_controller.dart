import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'bus_is_scrolled_controller.g.dart';

@riverpod
final class BusIsScrolledNotifier extends _$BusIsScrolledNotifier {
  @override
  bool build() {
    final now = DateTime.now().weekday;
    return now <= 5;
  }

  bool get value => state;

  set value(bool newValue) {
    state = newValue;
  }
}
