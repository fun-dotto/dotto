import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'map_on_map_search_controller.g.dart';

@riverpod
class OnMapSearchNotifier extends _$OnMapSearchNotifier {
  @override
  bool build() {
    return false;
  }

  void update(bool newValue) {
    state = newValue;
  }
}
