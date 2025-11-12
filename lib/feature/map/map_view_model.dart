import 'package:dotto/feature/map/domain/floor.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/feature/map/map_view_model_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_view_model.g.dart';

@riverpod
class MapViewModel extends _$MapViewModel {
  @override
  MapViewModelState build() {
    return const MapViewModelState(selectedFloor: Floor.third);
  }

  void onFloorButtonTapped(Floor floor) {
    state = state.copyWith(selectedFloor: floor);
  }

  void onSearchResultRowTapped(MapDetail mapDetail) {
    state = state.copyWith(selectedFloor: Floor.fromLabel(mapDetail.floor));
  }
}
