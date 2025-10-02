import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'focused_map_detail_controller.g.dart';

@riverpod
class FocusedMapDetailNotifier extends _$FocusedMapDetailNotifier {
  @override
  MapDetail build() {
    return MapDetail.none;
  }

  MapDetail get value => state;

  set value(MapDetail newValue) {
    state = newValue;
  }
}
