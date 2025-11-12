import 'package:dotto/feature/map/domain/floor.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/feature/map/domain/map_detail_map.dart';
import 'package:dotto/feature/map/map_view_model_state.dart';
import 'package:dotto/feature/map/repository/map_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_view_model.g.dart';

@riverpod
class MapViewModel extends _$MapViewModel {
  @override
  MapViewModelState build() {
    return MapViewModelState(
      selectedFloor: Floor.third,
      focusNode: FocusNode(),
      textEditingController: TextEditingController(),
      mapDetails: const AsyncValue.data([]),
    );
  }

  void onFloorButtonTapped(Floor floor) {
    state = state.copyWith(selectedFloor: floor);
  }

  void onSearchResultRowTapped(MapDetail mapDetail) {
    state.focusNode.unfocus();
    state = state.copyWith(selectedFloor: Floor.fromLabel(mapDetail.floor));
  }

  Future<void> onSearchTextChanged(String _) async {
    final mapDetails = await AsyncValue.guard(_search);
    state = state.copyWith(mapDetails: mapDetails);
  }

  Future<void> onSearchTextSubmitted(String _) async {
    final mapDetails = await AsyncValue.guard(_search);
    state = state.copyWith(mapDetails: mapDetails);
  }

  Future<void> onSearchTextCleared() async {
    final mapDetails = await AsyncValue.guard(_search);
    state = state.copyWith(mapDetails: mapDetails);
  }

  Future<List<MapDetail>> _search() async {
    if (state.textEditingController.text.isEmpty) {
      return [];
    }
    final map = await MapRepository().getMapDetailMapFromFirebase();
    final mapDetailMap = MapDetailMap(map);
    return mapDetailMap.searchAll(state.textEditingController.text);
  }
}
