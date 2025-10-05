import 'package:dotto/feature/map/controller/map_detail_map_controller.dart';
import 'package:dotto/feature/map/controller/map_search_bar_focus_controller.dart';
import 'package:dotto/feature/map/controller/map_search_text_controller.dart';
import 'package:dotto/feature/map/controller/on_map_search_controller.dart';
import 'package:dotto/feature/map/controller/search_list_controller.dart';
import 'package:dotto_design_system/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapSearchBar extends ConsumerWidget {
  const MapSearchBar({super.key});

  void _onSearchQueryChanged(WidgetRef ref, String text) {
    final mapDetailMap = ref.watch(mapDetailMapNotifierProvider);
    if (text.isEmpty) {
      ref.read(onMapSearchNotifierProvider.notifier).value = false;
      ref.read(mapSearchListNotifierProvider.notifier).list = [];
    } else {
      ref.read(onMapSearchNotifierProvider.notifier).value = true;
      mapDetailMap.whenData((data) {
        ref.read(mapSearchListNotifierProvider.notifier).list = data.searchAll(
          text,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = ref.watch(mapSearchTextNotifierProvider);
    final mapSearchBarFocus = ref.watch(mapSearchBarFocusNotifierProvider);
    return DottoTextField(
      controller: textEditingController,
      focusNode: mapSearchBarFocus,
      placeholder: '部屋名、教員名、メールアドレスなどで検索',
      onCleared: () {
        ref.read(mapSearchListNotifierProvider.notifier).list = [];
        ref.read(onMapSearchNotifierProvider.notifier).value = false;
      },
      onChanged: (text) {
        _onSearchQueryChanged(ref, text);
      },
      onSubmitted: (text) {
        _onSearchQueryChanged(ref, text);
      },
    );
  }
}
