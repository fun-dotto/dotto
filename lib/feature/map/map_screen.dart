import 'package:dotto/feature/map/controller/focused_map_detail_controller.dart';
import 'package:dotto/feature/map/controller/map_search_focus_node_controller.dart';
import 'package:dotto/feature/map/controller/map_search_has_focus_controller.dart';
import 'package:dotto/feature/map/controller/map_search_result_list_controller.dart';
import 'package:dotto/feature/map/controller/map_search_text_controller.dart';
import 'package:dotto/feature/map/controller/map_view_transformation_controller.dart';
import 'package:dotto/feature/map/controller/selected_floor_controller.dart';
import 'package:dotto/feature/map/domain/floor.dart';
import 'package:dotto/feature/map/widget/map.dart';
import 'package:dotto/feature/map/widget/map_date_picker.dart';
import 'package:dotto/feature/map/widget/map_detail_bottom_sheet.dart';
import 'package:dotto/feature/map/widget/map_floor_button.dart';
import 'package:dotto/feature/map/widget/map_legend.dart';
import 'package:dotto/feature/map/widget/map_search_bar.dart';
import 'package:dotto/feature/map/widget/map_search_result_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapViewTransformationController = ref.watch(
      mapViewTransformationNotifierProvider,
    );
    final focusNode = ref.watch(mapSearchFocusNodeNotifierProvider);
    final hasFocus = ref.watch(mapSearchHasFocusNotifierProvider);
    final list = ref.watch(mapSearchResultListNotifierProvider);
    final textEditingController = ref.watch(mapSearchTextNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('マップ'), centerTitle: false),
      body: Column(
        spacing: 8,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MapSearchBar(
              textEditingController: textEditingController,
              focusNode: focusNode,
              onChanged: (value) {
                ref.read(mapSearchResultListNotifierProvider.notifier).search();
              },
              onSubmitted: (value) {
                ref.read(mapSearchResultListNotifierProvider.notifier).search();
              },
              onCleared: () {
                ref.read(mapSearchResultListNotifierProvider.notifier).search();
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  spacing: 8,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: MapFloorButton(),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Column(
                            children: [
                              Map(
                                mapViewTransformationController:
                                    mapViewTransformationController,
                              ),
                              const Spacer(),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: MapLegend(),
                          ),
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: MapDatePicker(),
                      ),
                    ),
                  ],
                ),
                MapSearchResultList(
                  list: list,
                  hasFocus: hasFocus,
                  focusNode: focusNode,
                  onTapped: (item) {
                    focusNode.unfocus();
                    ref.read(selectedFloorNotifierProvider.notifier).value =
                        Floor.fromLabel(item.floor);
                    ref.read(focusedMapDetailNotifierProvider.notifier).value =
                        item;
                    ref
                        .read(mapViewTransformationNotifierProvider.notifier)
                        .value
                        .value
                        .setIdentity();
                    showBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return MapDetailBottomSheet(
                          floor: item.floor,
                          roomName: item.roomName,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
