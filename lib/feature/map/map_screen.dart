import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/map/controller/focused_map_detail_controller.dart';
import 'package:dotto/feature/map/controller/map_search_datetime_controller.dart';
import 'package:dotto/feature/map/controller/map_search_focus_node_controller.dart';
import 'package:dotto/feature/map/controller/map_search_has_focus_controller.dart';
import 'package:dotto/feature/map/controller/map_search_result_list_controller.dart';
import 'package:dotto/feature/map/controller/map_search_text_controller.dart';
import 'package:dotto/feature/map/controller/map_view_transformation_controller.dart';
import 'package:dotto/feature/map/controller/selected_floor_controller.dart';
import 'package:dotto/feature/map/controller/using_map_controller.dart';
import 'package:dotto/feature/map/domain/floor.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/feature/map/widget/map.dart';
import 'package:dotto/feature/map/widget/map_date_picker.dart';
import 'package:dotto/feature/map/widget/map_detail_bottom_sheet.dart';
import 'package:dotto/feature/map/widget/map_floor_button.dart';
import 'package:dotto/feature/map/widget/map_legend.dart';
import 'package:dotto/feature/map/widget/map_search_bar.dart';
import 'package:dotto/feature/map/widget/map_search_result_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  Widget _datePickerSection({
    required User? user,
    required DateTime searchDatetime,
    required void Function(DateTime) onPeriodButtonTapped,
    required void Function(DateTime) onDatePickerConfirmed,
  }) {
    if (user == null) {
      return const SizedBox.shrink();
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: MapDatePicker(
          searchDatetime: searchDatetime,
          onPeriodButtonTapped: onPeriodButtonTapped,
          onDatePickerConfirmed: onDatePickerConfirmed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final mapViewTransformationController = ref.watch(
      mapViewTransformationNotifierProvider,
    );
    final focusNode = ref.watch(mapSearchFocusNodeNotifierProvider);
    final hasFocus = ref.watch(mapSearchHasFocusNotifierProvider);
    final list = ref.watch(mapSearchResultListNotifierProvider);
    final textEditingController = ref.watch(mapSearchTextNotifierProvider);
    final selectedFloor = ref.watch(selectedFloorNotifierProvider);
    final searchDatetime = ref.watch(mapSearchDatetimeNotifierProvider);

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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: MapFloorButton(
                          selectedFloor: selectedFloor,
                          onPressed: (floor) {
                            ref
                                .read(
                                  mapViewTransformationNotifierProvider
                                      .notifier,
                                )
                                .value = TransformationController(
                              Matrix4(
                                1,
                                0,
                                0,
                                0,
                                0,
                                1,
                                0,
                                0,
                                0,
                                0,
                                1,
                                0,
                                0,
                                0,
                                0,
                                1,
                              ),
                            );
                            ref
                                    .read(
                                      selectedFloorNotifierProvider.notifier,
                                    )
                                    .value =
                                floor;
                            ref
                                .read(focusedMapDetailNotifierProvider.notifier)
                                .value = MapDetail
                                .none;
                            FocusScope.of(context).unfocus();
                          },
                        ),
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
                    _datePickerSection(
                      user: user,
                      searchDatetime: searchDatetime,
                      onPeriodButtonTapped: (dateTime) async {
                        var setDate = dateTime;
                        if (setDate.hour == 0) {
                          setDate = DateTime.now();
                        }
                        ref
                                .read(
                                  mapSearchDatetimeNotifierProvider.notifier,
                                )
                                .value =
                            setDate;
                        await ref
                            .read(usingMapNotifierProvider.notifier)
                            .setUsingColor(setDate, ref);
                      },
                      onDatePickerConfirmed: (dateTime) async {
                        ref
                                .read(
                                  mapSearchDatetimeNotifierProvider.notifier,
                                )
                                .value =
                            dateTime;
                        await ref
                            .read(usingMapNotifierProvider.notifier)
                            .setUsingColor(dateTime, ref);
                      },
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
