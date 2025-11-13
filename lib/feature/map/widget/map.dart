import 'package:dotto/domain/floor.dart';
import 'package:dotto/feature/map/widget/map_grid.dart';
import 'package:flutter/material.dart';

final class Map extends StatelessWidget {
  const Map({
    required this.mapViewTransformationController,
    required this.selectedFloor,
    super.key,
  });

  final TransformationController mapViewTransformationController;
  final Floor selectedFloor;

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
        child: MapGridScreen(selectedFloor: selectedFloor),
      ),
    );
  }
}
