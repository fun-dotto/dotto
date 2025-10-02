import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'on_map_search_controller.g.dart';

@riverpod
class OnMapSearchNotifier extends _$OnMapSearchNotifier {
  @override
  bool build() {
    return false;
  }

  bool get value => state;

  set value(bool newValue) {
    state = newValue;
  }
}
