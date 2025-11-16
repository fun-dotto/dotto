import 'package:collection/collection.dart';
import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/feature/map/fun_map.dart';
import 'package:dotto/feature/map/widget/map_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final class MapGridScreen extends StatelessWidget {
  const MapGridScreen({
    required this.selectedFloor,
    required this.rooms,
    required this.focusedMapTileProps,
    required this.dateTime,
    required this.onTapped,
    super.key,
  });

  final Floor selectedFloor;
  final List<Room> rooms;
  final MapTileProps? focusedMapTileProps;
  final DateTime dateTime;
  final void Function(MapTileProps, Room?)? onTapped;

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 48,
      // For debug
      // mainAxisSpacing: 1,
      // crossAxisSpacing: 1,
      children: [
        ...FUNMap.tileProps
            .where((e) => e.floor == selectedFloor)
            .map(
              (e) => StaggeredGridTile.count(
                crossAxisCellCount: e.width,
                mainAxisCellCount: e.height,
                child: MapTile(
                  props: e,
                  room: rooms.firstWhereOrNull((room) => room.id == e.id),
                  isFocused: e.id != null && focusedMapTileProps?.id == e.id,
                  dateTime: dateTime,
                  onTapped: onTapped,
                ),
              ),
            ),
      ],
    );
  }
}
