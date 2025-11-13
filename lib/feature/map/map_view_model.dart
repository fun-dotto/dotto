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
      searchDatetime: DateTime.now(),
      transformationController: TransformationController(Matrix4.identity()),
      focusedMapDetail: MapDetail.none,
    );
  }

  void onFloorButtonTapped(Floor floor) {
    state.focusNode.unfocus();
    state = state.copyWith(
      selectedFloor: floor,
      focusedMapDetail: MapDetail.none,
    );
    state.transformationController.value = Matrix4(
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    );
  }

  void onSearchResultRowTapped(MapDetail mapDetail) {
    state.focusNode.unfocus();
    state = state.copyWith(
      selectedFloor: Floor.fromLabel(mapDetail.floor),
      focusedMapDetail: mapDetail,
    );
    state.transformationController.value.setIdentity();
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

  void onPeriodButtonTapped(DateTime dateTime) {
    state = state.copyWith(searchDatetime: dateTime);
  }

  void onDatePickerConfirmed(DateTime dateTime) {
    state = state.copyWith(searchDatetime: dateTime);
  }
}
