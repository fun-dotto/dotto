import 'package:flutter/material.dart';

// 階段の時の描画設定
final class MapStairType {
  const MapStairType(this.direction, {required this.up, required this.down});
  final Axis direction;
  final bool up;
  final bool down;
  Axis getDirection() {
    return direction;
  }
}
