import 'package:dotto/domain/map_colors.dart';
import 'package:flutter/material.dart';

final class MapLegend extends StatelessWidget {
  const MapLegend({super.key});

  Widget _mapInfoTile(Color color, String text) {
    return Row(
      spacing: 4,
      children: [
        Container(
          decoration: BoxDecoration(color: color, border: Border.all()),
          width: 10,
          height: 10,
        ),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 64,
      color: Colors.black.withValues(alpha: 0.1),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _mapInfoTile(MapColors.roomInUseTile, '使用中'),
          _mapInfoTile(MapColors.restroomTile, 'トイレ・給湯室'),
        ],
      ),
    );
  }
}
