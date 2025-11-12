import 'package:dotto/feature/map/domain/floor.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_view_model_state.freezed.dart';

@freezed
abstract class MapViewModelState with _$MapViewModelState {
  const factory MapViewModelState({required Floor selectedFloor}) =
      _MapViewModelState;
}
