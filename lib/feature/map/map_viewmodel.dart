import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/feature/map/fun_map.dart';
import 'package:dotto/feature/map/map_service.dart';
import 'package:dotto/feature/map/map_viewstate.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_viewmodel.g.dart';

@riverpod
class MapViewModel extends _$MapViewModel {
  @override
  Future<MapViewState> build() async {
    final rooms = await MapService(ref).getRooms();
    final state = MapViewState(
      rooms: rooms,
      filteredRooms: [],
      focusedMapTileProps: null,
      searchDatetime: DateTime.now(),
      selectedFloor: Floor.third,
      focusNode: FocusNode(),
      textEditingController: TextEditingController(),
      transformationController: TransformationController(Matrix4.identity()),
    );
    return state;
  }

  void onFloorButtonTapped(Floor floor) {
    state.value?.focusNode.unfocus();
    final newState = state.value?.copyWith(
      selectedFloor: floor,
      focusedMapTileProps: null,
    );
    if (newState != null) {
      state = AsyncData(newState);
    }
    state.value?.transformationController.value = Matrix4(
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

  Future<void> onSearchTextChanged(String query) async {
    final filteredRooms = await _search(query);
    final newState = state.value?.copyWith(filteredRooms: filteredRooms);
    if (newState != null) {
      state = AsyncData(newState);
    }
  }

  Future<void> onSearchTextSubmitted(String query) async {
    final filteredRooms = await _search(query);
    final newState = state.value?.copyWith(filteredRooms: filteredRooms);
    if (newState != null) {
      state = AsyncData(newState);
    }
  }

  void onSearchTextCleared() {
    final newState = state.value?.copyWith(filteredRooms: const []);
    if (newState != null) {
      state = AsyncData(newState);
    }
  }

  Future<List<Room>> _search(String query) async {
    if (query.isEmpty) {
      return [];
    }
    return (state.value?.rooms ?? [])
        .where(
          (room) =>
              room.id.toLowerCase().contains(query.toLowerCase()) ||
              room.name.toLowerCase().contains(query.toLowerCase()) ||
              room.description.toLowerCase().contains(query.toLowerCase()) ||
              room.email.toLowerCase().contains(query.toLowerCase()) ||
              room.keywords.any(
                (keyword) =>
                    keyword.toLowerCase().contains(query.toLowerCase()),
              ),
        )
        .toList();
  }

  void onSearchResultRowTapped(Room room) {
    state.value?.focusNode.unfocus();
    final newState = state.value?.copyWith(
      selectedFloor: room.floor,
      focusedMapTileProps: ref
          .read(funMapProvider)
          .firstWhereOrNull((e) => e.id == room.id),
    );
    if (newState != null) {
      state = AsyncData(newState);
    }
  }

  void onPeriodButtonTapped(DateTime dateTime) {
    final newState = state.value?.copyWith(searchDatetime: dateTime);
    if (newState != null) {
      state = AsyncData(newState);
    }
  }

  void onDatePickerConfirmed(DateTime dateTime) {
    final newState = state.value?.copyWith(searchDatetime: dateTime);
    if (newState != null) {
      state = AsyncData(newState);
    }
  }

  void onMapTileTapped(MapTileProps props, Room? room) {
    state.value?.focusNode.unfocus();
    MapViewState? newState;
    if (props == state.value?.focusedMapTileProps) {
      newState = state.value?.copyWith(focusedMapTileProps: null);
    } else {
      newState = state.value?.copyWith(focusedMapTileProps: props);
    }
    if (newState != null) {
      state = AsyncData(newState);
    }
  }

  void onBottomSheetDismissed() {
    final newState = state.value?.copyWith(focusedMapTileProps: null);
    if (newState != null) {
      state = AsyncData(newState);
    }
  }
}
