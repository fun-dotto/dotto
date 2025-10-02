import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'map_view_transformation_controller.g.dart';

@riverpod
class MapViewTransformationNotifier extends _$MapViewTransformationNotifier {
  @override
  TransformationController build() {
    return TransformationController(Matrix4.identity());
  }

  TransformationController get value => state;

  set value(TransformationController newValue) {
    state = newValue;
  }
}
