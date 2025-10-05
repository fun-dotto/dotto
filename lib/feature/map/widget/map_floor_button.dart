import 'package:dotto/feature/map/controller/focused_map_detail_controller.dart';
import 'package:dotto/feature/map/controller/map_page_controller.dart';
import 'package:dotto/feature/map/controller/map_view_transformation_controller.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/theme/v1/color_fun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapFloorButton extends ConsumerWidget {
  const MapFloorButton({super.key});

  static const List<String> floorBarString = [
    '1',
    '2',
    '3',
    '4',
    '5',
    'R6',
    'R7',
  ];

  Widget _floorButton(BuildContext context, WidgetRef ref, int index) {
    final mapPage = ref.watch(mapPageNotifierProvider);
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: mapPage == index ? Colors.black12 : null,
      ),
      // 階数の変更をProviderに渡す
      onPressed: () {
        ref
            .read(mapViewTransformationNotifierProvider.notifier)
            .value = TransformationController(
          Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1),
        );
        ref.read(mapPageNotifierProvider.notifier).value = index;
        ref.read(focusedMapDetailNotifierProvider.notifier).value =
            MapDetail.none;
        FocusScope.of(context).unfocus();
      },
      child: Text(
        floorBarString[index],
        style: TextStyle(
          fontSize: 18,
          color: mapPage == index ? customFunColor : Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      children: List.generate(floorBarString.length, (index) {
        return _floorButton(context, ref, index);
      }),
    );
  }
}
