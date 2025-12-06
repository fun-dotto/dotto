import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/domain/room.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_viewstate.freezed.dart';

@freezed
abstract class MapViewState with _$MapViewState {
  const factory MapViewState({
    required List<Room> rooms,
    required List<Room> filteredRooms,
    required MapTileProps? focusedMapTileProps,
    required DateTime searchDatetime,
    required Floor selectedFloor,
    required FocusNode focusNode,
    required TextEditingController textEditingController,
    required TransformationController transformationController,
  }) = _MapViewState;
}
