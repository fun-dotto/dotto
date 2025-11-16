import 'package:dotto/controller/tab_controller.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/tab_item.dart';
import 'package:dotto/feature/map/fun_map.dart';
import 'package:dotto/feature/map/map_view_model.dart';
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
    final asyncViewModel = ref.watch(mapViewModelProvider);

    final user = ref.watch(userProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('マップ'), centerTitle: false),
      body: asyncViewModel.when(
        data: (viewModel) => Column(
          spacing: 8,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MapSearchBar(
                textEditingController: viewModel.textEditingController,
                focusNode: viewModel.focusNode,
                onChanged: (value) {
                  ref
                      .read(mapViewModelProvider.notifier)
                      .onSearchTextChanged(value);
                },
                onSubmitted: (value) {
                  ref
                      .read(mapViewModelProvider.notifier)
                      .onSearchTextSubmitted(value);
                },
                onCleared: () {
                  ref.read(mapViewModelProvider.notifier).onSearchTextCleared();
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
                            selectedFloor: viewModel.selectedFloor,
                            onPressed: (floor) {
                              ref
                                  .read(mapViewModelProvider.notifier)
                                  .onFloorButtonTapped(floor);
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
                                      viewModel.transformationController,
                                  selectedFloor: viewModel.selectedFloor,
                                  rooms: viewModel.rooms,
                                  focusedRoom: viewModel.focusedRoom,
                                  dateTime: viewModel.searchDatetime,
                                  onTapped: (props, room) {
                                    ref
                                        .read(mapViewModelProvider.notifier)
                                        .onMapTileTapped(props, room);
                                    if (room != null) {
                                      showBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MapDetailBottomSheet(
                                            props: props,
                                            room: room,
                                            dateTime: viewModel.searchDatetime,
                                            isLoggedIn: user != null,
                                            onGoToSettingButtonTapped: () {
                                              ref
                                                  .read(
                                                    tabItemProvider.notifier,
                                                  )
                                                  .selected(TabItem.setting);
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
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
                        searchDatetime: viewModel.searchDatetime,
                        onPeriodButtonTapped: (dateTime) async {
                          var setDate = dateTime;
                          if (setDate.hour == 0) {
                            setDate = DateTime.now();
                          }
                          ref
                              .read(mapViewModelProvider.notifier)
                              .onPeriodButtonTapped(setDate);
                        },
                        onDatePickerConfirmed: (dateTime) async {
                          ref
                              .read(mapViewModelProvider.notifier)
                              .onDatePickerConfirmed(dateTime);
                        },
                      ),
                    ],
                  ),
                  MapSearchResultList(
                    rooms: viewModel.filteredRooms,
                    onTapped: (item) {
                      ref
                          .read(mapViewModelProvider.notifier)
                          .onSearchResultRowTapped(item);

                      showBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return MapDetailBottomSheet(
                            props: FUNMap.tileProps.firstWhere(
                              (e) => e.id == item.id,
                            ),
                            room: item,
                            dateTime: viewModel.searchDatetime,
                            isLoggedIn: user != null,
                            onGoToSettingButtonTapped: () {
                              ref
                                  .read(tabItemProvider.notifier)
                                  .selected(TabItem.setting);
                            },
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
        error: (error, stackTrace) => const Center(child: Text('エラーが発生しました')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
