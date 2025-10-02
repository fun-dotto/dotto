import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'map_search_text_controller.g.dart';

@riverpod
class MapSearchTextNotifier extends _$MapSearchTextNotifier {
  @override
  TextEditingController build() {
    return TextEditingController();
  }
}
