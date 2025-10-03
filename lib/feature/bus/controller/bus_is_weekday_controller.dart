import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'bus_is_weekday_controller.g.dart';

@riverpod
final class BusIsWeekdayNotifier extends _$BusIsWeekdayNotifier {
  @override
  bool build() {
    final now = DateTime.now().weekday;
    return now <= 5;
  }

  void toggle() {
    state = !state;
  }
}
