import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'map_search_focus_node_controller.g.dart';

@riverpod
class MapSearchFocusNodeNotifier extends _$MapSearchFocusNodeNotifier {
  @override
  FocusNode build() {
    return FocusNode();
  }
}
