import 'package:dotto/feature/map/controller/focused_map_detail_controller.dart';
import 'package:dotto/feature/map/controller/map_detail_map_controller.dart';
import 'package:dotto/feature/map/controller/map_page_controller.dart';
import 'package:dotto/feature/map/controller/map_search_bar_focus_controller.dart';
import 'package:dotto/feature/map/controller/map_search_text_controller.dart';
import 'package:dotto/feature/map/controller/map_view_transformation_controller.dart';
import 'package:dotto/feature/map/controller/on_map_search_controller.dart';
import 'package:dotto/feature/map/controller/search_list_controller.dart';
import 'package:dotto/feature/map/widget/map_detail_bottom_sheet.dart';
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

/// 背景の色を設定
final class MapBarrierOnSearch extends ConsumerWidget {
  const MapBarrierOnSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapSearchList = ref.watch(mapSearchListNotifierProvider);
    if (mapSearchList.isNotEmpty) {
      return ColoredBox(
        color: Colors.white.withValues(alpha: 0.9),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: const SizedBox.expand(),
          onTap: () {
            ref.read(mapSearchListNotifierProvider.notifier).list = [];
          },
        ),
      );
    } else {
      return Container();
    }
  }
}

/// 検索予測結果
final class MapSearchListView extends ConsumerWidget {
  const MapSearchListView({super.key});

  static const List<String> floorBarString = [
    '1',
    '2',
    '3',
    '4',
    '5',
    'R6',
    'R7',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapSearchList = ref.watch(mapSearchListNotifierProvider);
    final mapSearchBarFocusNotifier = ref.watch(
      mapSearchBarFocusNotifierProvider,
    );
    if (mapSearchList.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: ListView.separated(
              itemCount: mapSearchList.length,
              itemBuilder: (context, int index) {
                final item = mapSearchList[index];
                return ListTile(
                  leading: Text('${item.floor}F'),
                  title: Text(item.header),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ref.read(mapSearchListNotifierProvider.notifier).list = [];
                    FocusScope.of(context).unfocus();
                    ref
                        .read(mapViewTransformationNotifierProvider.notifier)
                        .value
                        .value
                        .setIdentity();
                    ref.read(focusedMapDetailNotifierProvider.notifier).value =
                        item;
                    ref.read(mapPageNotifierProvider.notifier).value =
                        floorBarString.indexOf(item.floor);
                    showBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return MapDetailBottomSheet(
                          floor: item.floor,
                          roomName: item.roomName,
                        );
                      },
                    );
                    mapSearchBarFocusNotifier.unfocus();
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 1),
            ),
          ),
        ],
      ),
    );
  }
}
