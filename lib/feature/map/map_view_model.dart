import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/feature/map/map_service.dart';
import 'package:dotto/feature/map/map_view_model_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_view_model.g.dart';

@riverpod
class MapViewModel extends _$MapViewModel {
  @override
  MapViewModelState build() {
    final state = MapViewModelState(
      rooms: [],
      filteredRooms: [],
      focusedRoom: null,
      searchDatetime: DateTime.now(),
      selectedFloor: Floor.third,
      focusNode: FocusNode(),
      textEditingController: TextEditingController(),
      transformationController: TransformationController(Matrix4.identity()),
    );
    _getRooms(ref);
    return state;
  }

  void onFloorButtonTapped(Floor floor) {
    state.focusNode.unfocus();
    state = state.copyWith(selectedFloor: floor, focusedRoom: null);
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

  void onSearchResultRowTapped(Room room) {
    state.focusNode.unfocus();
    state = state.copyWith(selectedFloor: room.floor, focusedRoom: room);
    state.transformationController.value.setIdentity();
  }

  Future<void> onSearchTextChanged(String _) async {
    final rooms = await _search();
    state = state.copyWith(rooms: rooms);
  }

  Future<void> onSearchTextSubmitted(String _) async {
    final rooms = await _search();
    state = state.copyWith(rooms: rooms);
  }

  Future<void> onSearchTextCleared() async {
    final filteredRooms = await _search();
    state = state.copyWith(filteredRooms: filteredRooms);
  }

  Future<List<Room>> _search() async {
    if (state.textEditingController.text.isEmpty) {
      return [];
    }
    return state.rooms
        .where(
          (room) =>
              room.id.toLowerCase().contains(
                state.textEditingController.text.toLowerCase(),
              ) ||
              room.name.toLowerCase().contains(
                state.textEditingController.text.toLowerCase(),
              ) ||
              room.description.toLowerCase().contains(
                state.textEditingController.text.toLowerCase(),
              ) ||
              room.email.toLowerCase().contains(
                state.textEditingController.text.toLowerCase(),
              ) ||
              room.keywords.any(
                (keyword) => keyword.toLowerCase().contains(
                  state.textEditingController.text.toLowerCase(),
                ),
              ),
        )
        .toList();
  }

  void onPeriodButtonTapped(DateTime dateTime) {
    state = state.copyWith(searchDatetime: dateTime);
  }

  void onDatePickerConfirmed(DateTime dateTime) {
    state = state.copyWith(searchDatetime: dateTime);
  }

  Future<void> _getRooms(Ref ref) async {
    final rooms = await MapService(ref: ref).getRooms();
    state = state.copyWith(rooms: rooms);
  }
}
