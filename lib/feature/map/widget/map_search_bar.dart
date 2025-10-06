import 'package:dotto/feature/map/controller/map_search_focus_node_controller.dart';
import 'package:dotto/feature/map/controller/map_search_result_list_controller.dart';
import 'package:dotto/feature/map/controller/map_search_text_controller.dart';
import 'package:dotto_design_system/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapSearchBar extends ConsumerWidget {
  const MapSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = ref.watch(mapSearchTextNotifierProvider);
    final focusNode = ref.watch(mapSearchFocusNodeNotifierProvider);
    return DottoTextField(
      controller: textEditingController,
      focusNode: focusNode,
      placeholder: '部屋名、教員名、メールアドレスで検索',
      onChanged: (_) =>
          ref.read(mapSearchResultListNotifierProvider.notifier).search(),
      onSubmitted: (_) =>
          ref.read(mapSearchResultListNotifierProvider.notifier).search(),
      onCleared: () =>
          ref.read(mapSearchResultListNotifierProvider.notifier).search(),
    );
  }
}
