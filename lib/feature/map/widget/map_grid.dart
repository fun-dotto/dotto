import 'package:dotto/feature/map/domain/floor.dart';
import 'package:dotto/feature/map/widget/fun_grid_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final class MapGridScreen extends StatelessWidget {
  const MapGridScreen({required this.selectedFloor, super.key});
  final Floor selectedFloor;

  @override
  Widget build(BuildContext context) {
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
  }
}
