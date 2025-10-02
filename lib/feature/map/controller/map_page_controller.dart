import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'map_page_controller.g.dart';

@riverpod
class MapPageNotifier extends _$MapPageNotifier {
  @override
  int build() {
    return 2;
  }

  int get value => state;

  set value(int newValue) {
    state = newValue;
  }
}
