import 'package:dotto/domain/floor.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/feature/map/domain/map_detail_map.dart';
import 'package:dotto/feature/map/map_service.dart';
import 'package:dotto/feature/map/map_view_model_state.dart';
import 'package:dotto/feature/map/repository/map_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_view_model.g.dart';

@riverpod
class MapViewModel extends _$MapViewModel {
  @override
  MapViewModelState build() {
    _getRooms(ref);
    return MapViewModelState(
      selectedFloor: Floor.third,
      focusNode: FocusNode(),
      textEditingController: TextEditingController(),
      rooms: const AsyncValue.loading(),
      mapDetails: const AsyncValue.loading(),
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

  Future<void> _getRooms(Ref ref) async {
    final rooms = await AsyncValue.guard(MapService(ref: ref).getRooms);
    state = state.copyWith(rooms: rooms);
  }
}
