import 'package:dotto/feature/map/controller/map_view_transformation_controller.dart';
import 'package:dotto/feature/map/widget/map_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class Map extends ConsumerWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapViewTransformationController = ref.watch(
      mapViewTransformationNotifierProvider,
    );
    return Flexible(
      child: InteractiveViewer(
        maxScale: 10,
        // 倍率行列Matrix4
        transformationController: mapViewTransformationController,
        child: const Padding(
          // マップをちょうどよく表示するための余白
          padding: EdgeInsets.only(left: 20, right: 20),
          // マップ表示
          child: MapGridScreen(),
        ),
      ),
    );
  }
}
