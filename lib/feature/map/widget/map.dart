import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/feature/map/widget/map_grid.dart';
import 'package:flutter/material.dart';

final class Map extends StatelessWidget {
  const Map({
    required this.mapViewTransformationController,
    required this.selectedFloor,
    required this.rooms,
    required this.focusedMapTileProps,
    required this.dateTime,
    required this.onTapped,
    super.key,
  });

  final TransformationController mapViewTransformationController;
  final Floor selectedFloor;
  final List<Room> rooms;
  final MapTileProps? focusedMapTileProps;
  final DateTime dateTime;
  final void Function(MapTileProps, Room?)? onTapped;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 10,
      // 倍率行列Matrix4
      transformationController: mapViewTransformationController,
      child: Padding(
        // マップをちょうどよく表示するための余白
        padding: const EdgeInsets.symmetric(horizontal: 20),
        // マップ表示
        child: MapGridScreen(
          selectedFloor: selectedFloor,
          rooms: rooms,
          focusedMapTileProps: focusedMapTileProps,
          dateTime: dateTime,
          onTapped: onTapped,
        ),
      ),
    );
  }
}
