import 'package:dotto/feature/map/controller/selected_floor_controller.dart';
import 'package:dotto/feature/map/widget/fun_grid_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final class MapGridScreen extends StatelessWidget {
  const MapGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final selectedFloor = ref.watch(selectedFloorNotifierProvider);
        return StaggeredGrid.count(
          crossAxisCount: 48,
          children: [
            ...FunGridMaps.mapTileListMap[selectedFloor.label]!.map((e) {
              return StaggeredGridTile.count(
                crossAxisCellCount: e.width,
                mainAxisCellCount: e.height,
                child: e,
              );
            }),
          ],
        );
      },
    );
  }
}
