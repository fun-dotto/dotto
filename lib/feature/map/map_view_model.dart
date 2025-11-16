import 'dart:async';

import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/feature/map/map_usecase.dart';
import 'package:dotto/feature/map/map_view_model_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_view_model.g.dart';

@riverpod
class MapViewModel extends _$MapViewModel {
  @override
  Future<MapViewModelState> build() async {
    final rooms = await MapUseCase(ref: ref).getRooms();
    final state = MapViewModelState(
      rooms: rooms,
      filteredRooms: [],
      focusedRoom: null,
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
      focusedRoom: null,
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

  void onSearchResultRowTapped(Room room) {
    state.value?.focusNode.unfocus();
    final newState = state.value?.copyWith(
      selectedFloor: room.floor,
      focusedRoom: room,
    );
    if (newState != null) {
      state = AsyncData(newState);
    }
    state.value?.transformationController.value.setIdentity();
  }

  Future<void> onSearchTextChanged(String _) async {
    final filteredRooms = await _search();
    final newState = state.value?.copyWith(filteredRooms: filteredRooms);
    if (newState != null) {
      state = AsyncData(newState);
    }
  }

  Future<void> onSearchTextSubmitted(String _) async {
    final filteredRooms = await _search();
    final newState = state.value?.copyWith(filteredRooms: filteredRooms);
    if (newState != null) {
      state = AsyncData(newState);
    }
  }

  Future<void> onSearchTextCleared() async {
    final filteredRooms = await _search();
    final newState = state.value?.copyWith(filteredRooms: filteredRooms);
    if (newState != null) {
      state = AsyncData(newState);
    }
  }

  Future<List<Room>> _search() async {
    if (state.value?.textEditingController.text.isEmpty ?? true) {
      return [];
    }
    return (state.value?.rooms ?? [])
        .where(
          (room) =>
              room.id.toLowerCase().contains(
                state.value?.textEditingController.text.toLowerCase() ?? '',
              ) ||
              room.name.toLowerCase().contains(
                state.value?.textEditingController.text.toLowerCase() ?? '',
              ) ||
              room.description.toLowerCase().contains(
                state.value?.textEditingController.text.toLowerCase() ?? '',
              ) ||
              room.email.toLowerCase().contains(
                state.value?.textEditingController.text.toLowerCase() ?? '',
              ) ||
              room.keywords.any(
                (keyword) => keyword.toLowerCase().contains(
                  state.value?.textEditingController.text.toLowerCase() ?? '',
                ),
              ),
        )
        .toList();
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
    final newState = state.value?.copyWith(focusedRoom: room);
    if (newState != null) {
      state = AsyncData(newState);
    }
    state.value?.focusNode.unfocus();
  }
}
