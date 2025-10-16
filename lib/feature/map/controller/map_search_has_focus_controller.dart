import 'package:dotto/feature/map/controller/map_search_focus_node_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'map_search_has_focus_controller.g.dart';

@riverpod
class MapSearchHasFocusNotifier extends _$MapSearchHasFocusNotifier {
  @override
  bool build() {
    final focusNode = ref.watch(mapSearchFocusNodeNotifierProvider);

    // FocusNodeのリスナーを追加して、状態変化を検知
    void listener() {
      state = focusNode.hasFocus;
    }

    focusNode.addListener(listener);
    ref.onDispose(() => focusNode.removeListener(listener));

    return focusNode.hasFocus;
  }
}
