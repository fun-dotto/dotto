import 'package:dotto/feature/map/controller/focused_map_detail_controller.dart';
import 'package:dotto/feature/map/controller/map_view_transformation_controller.dart';
import 'package:dotto/feature/map/controller/selected_floor_controller.dart';
import 'package:dotto/feature/map/domain/floor.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/theme/v1/color_fun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapFloorButton extends ConsumerWidget {
  const MapFloorButton({super.key});

  Widget _floorButton(BuildContext context, WidgetRef ref, Floor floor) {
    final selectedFloor = ref.watch(selectedFloorNotifierProvider);
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: selectedFloor == floor ? Colors.black12 : null,
      ),
      // 階数の変更をProviderに渡す
      onPressed: () {
        ref
            .read(mapViewTransformationNotifierProvider.notifier)
            .value = TransformationController(
          Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1),
        );
        ref.read(selectedFloorNotifierProvider.notifier).value = floor;
        ref.read(focusedMapDetailNotifierProvider.notifier).value =
            MapDetail.none;
        FocusScope.of(context).unfocus();
      },
      child: Text(
        floor.label,
        style: TextStyle(
          fontSize: 18,
          color: selectedFloor == floor ? customFunColor : Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: Floor.values.length,
      children: List.generate(Floor.values.length, (index) {
        return _floorButton(context, ref, Floor.values[index]);
      }),
    );
  }
}
