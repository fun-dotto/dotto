import 'package:dotto/feature/map/domain/floor.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_view_model_state.freezed.dart';

@freezed
abstract class MapViewModelState with _$MapViewModelState {
  const factory MapViewModelState({
    required Floor selectedFloor,
    required FocusNode focusNode,
    required TextEditingController textEditingController,
    required AsyncValue<List<MapDetail>> mapDetails,
  }) = _MapViewModelState;
}
