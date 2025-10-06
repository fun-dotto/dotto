import 'package:dotto/feature/map/controller/focused_map_detail_controller.dart';
import 'package:dotto/feature/map/controller/map_search_focus_node_controller.dart';
import 'package:dotto/feature/map/controller/map_search_result_list_controller.dart';
import 'package:dotto/feature/map/controller/map_view_transformation_controller.dart';
import 'package:dotto/feature/map/controller/selected_floor_controller.dart';
import 'package:dotto/feature/map/domain/floor.dart';
import 'package:dotto/feature/map/widget/map_detail_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapSearchResultList extends ConsumerWidget {
  const MapSearchResultList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = ref.watch(mapSearchFocusNodeNotifierProvider);
    final list = ref.watch(mapSearchResultListNotifierProvider);
    return list.when(
      data: (data) {
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, _) => const Divider(height: 0),
                  itemBuilder: (context, int index) {
                    final item = data[index];
                    return ListTile(
                      title: Text(item.header),
                      onTap: () {
                        focusNode.unfocus();
                        ref.read(selectedFloorNotifierProvider.notifier).value =
                            Floor.fromLabel(item.floor);
                        ref
                                .read(focusedMapDetailNotifierProvider.notifier)
                                .value =
                            item;
                        ref
                            .read(
                              mapViewTransformationNotifierProvider.notifier,
                            )
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
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stack) {
        return const SizedBox.shrink();
      },
      loading: () {
        return const SizedBox.shrink();
      },
    );
  }
}
