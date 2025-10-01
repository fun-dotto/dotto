import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'map_search_list_controller.g.dart';

@riverpod
class MapSearchListNotifier extends _$MapSearchListNotifier {
  @override
  List<MapDetail> build() {
    return [];
  }

  List<MapDetail> get list => state;

  set list(List<MapDetail> newValue) {
    super.state = newValue;
  }
}
