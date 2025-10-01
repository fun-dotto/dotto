import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'map_search_bar_focus_controller.g.dart';

@riverpod
class MapSearchBarFocusNotifier extends _$MapSearchBarFocusNotifier {
  @override
  FocusNode build() {
    return FocusNode();
  }
}
