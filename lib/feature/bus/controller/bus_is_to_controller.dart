import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'bus_is_to_controller.g.dart';

@riverpod
final class BusIsToNotifier extends _$BusIsToNotifier {
  @override
  bool build() {
    return true;
  }

  void toggle() {
    state = !state;
  }
}
