import 'package:dotto/feature/map/domain/map_tile_type.dart';
import 'package:dotto/feature/map/widget/map_tile.dart';
import 'package:flutter/material.dart';

final class MapLegend extends StatelessWidget {
  const MapLegend({super.key});

  Widget _mapInfoTile(Color color, String text) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(color: color, border: Border.all()),
          width: 11,
          height: 11,
        ),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 245,
      color: Colors.black.withValues(alpha: 0.1),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _mapInfoTile(MapColors.using, '下記設定時間に授業等で使用中の部屋'),
          _mapInfoTile(MapTileType.wc.backgroundColor, 'トイレ及び給湯室'),
          _mapInfoTile(Colors.red, '検索結果'),
        ],
      ),
    );
  }
}
