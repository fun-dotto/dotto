import 'package:dotto/feature/map/controller/focused_map_detail_controller.dart';
import 'package:dotto/feature/map/controller/map_search_bar_focus_controller.dart';
import 'package:dotto/feature/map/controller/map_view_transformation_controller.dart';
import 'package:dotto/feature/map/controller/search_list_controller.dart';
import 'package:dotto/feature/map/controller/selected_floor_controller.dart';
import 'package:dotto/feature/map/domain/floor.dart';
import 'package:dotto/feature/map/widget/map_detail_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapSearchResultList extends ConsumerWidget {
  const MapSearchResultList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapSearchList = ref.watch(mapSearchListNotifierProvider);
    final mapSearchBarFocusNotifier = ref.watch(
      mapSearchBarFocusNotifierProvider,
    );
    if (mapSearchList.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: ListView.separated(
              itemCount: mapSearchList.length,
              separatorBuilder: (_, _) => const Divider(height: 0),
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
                    ref.read(selectedFloorNotifierProvider.notifier).value =
                        Floor.fromLabel(item.floor);
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
            ),
          ),
        ],
      ),
    );
  }
}
