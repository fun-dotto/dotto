import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/room.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_view_model_state.freezed.dart';

@freezed
abstract class MapViewModelState with _$MapViewModelState {
  const factory MapViewModelState({
    required List<Room> rooms,
    required List<Room> filteredRooms,
    required Room? focusedRoom,
    required DateTime searchDatetime,
    required Floor selectedFloor,
    required FocusNode focusNode,
    required TextEditingController textEditingController,
    required TransformationController transformationController,
  }) = _MapViewModelState;
}
