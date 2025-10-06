import 'package:dotto/feature/map/domain/floor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_floor_controller.g.dart';

@riverpod
final class SelectedFloorNotifier extends _$SelectedFloorNotifier {
  @override
  Floor build() {
    return Floor.third;
  }

  Floor get value => state;

  set value(Floor newValue) {
    state = newValue;
  }
}
