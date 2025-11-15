import 'package:dotto/domain/room.dart';
import 'package:dotto/domain/room_equipment.dart';
import 'package:dotto/feature/map/widget/fun_grid_map.dart';
import 'package:dotto/feature/map/widget/map_tile.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class MapDetailBottomSheet extends StatelessWidget {
  const MapDetailBottomSheet({
    required this.room,
    required this.isLoggedIn,
    required this.onGoToSettingButtonTapped,
    super.key,
  });

  final Room room;
  final bool isLoggedIn;
  final void Function() onGoToSettingButtonTapped;

  static const Color blue = Color(0xFF4A90E2);

  Widget scheduleTile(
    BuildContext context,
    DateTime begin,
    DateTime end,
    String title,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(width: 5, color: blue)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            title,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('MM/dd').format(begin),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 5),
              Text(
                '${DateFormat('HH:mm').format(begin)} ~ '
                '${DateFormat('HH:mm').format(end)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          // time
        ],
      ),
    );
  }

  Widget roomAvailable(RoomEquipment type, int status) {
    const fontColor = Colors.white;
    var icon = Icons.close_outlined;
    if (status == 1) {
      icon = Icons.change_history_outlined;
    } else if (status == 2) {
      icon = Icons.circle_outlined;
    }
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: blue.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(type.icon, color: fontColor, size: 20),
          Text(type.label, style: const TextStyle(color: fontColor)),
          Icon(icon, color: fontColor, size: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MapTile? gridMap;
    final mapTileList = FunGridMaps.mapTileListMap[room.floor.label];
    if (mapTileList != null) {
      final foundTiles = mapTileList.where(
        (element) => element.txt == room.name,
      );
      gridMap = foundTiles.isNotEmpty ? foundTiles.first : null;
    }
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  room.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          if (isLoggedIn)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (gridMap != null) ...[
                      Wrap(
                        spacing: 8,
                        children: [
                          if (gridMap.food != null &&
                              gridMap.drink != null) ...[
                            roomAvailable(
                              RoomEquipment.food,
                              gridMap.food! ? 2 : 0,
                            ),
                            roomAvailable(
                              RoomEquipment.drink,
                              gridMap.drink! ? 2 : 0,
                            ),
                          ],
                          if (gridMap.outlet != null)
                            roomAvailable(
                              RoomEquipment.outlet,
                              gridMap.outlet!,
                            ),
                        ],
                      ),
                    ],
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (room.schedules.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: room.schedules
                                .map(
                                  (e) => scheduleTile(
                                    context,
                                    e.beginDatetime,
                                    e.endDatetime,
                                    e.title,
                                  ),
                                )
                                .toList(),
                          )
                        else if (room.description.isNotEmpty)
                          SelectableText(room.description),
                        if (room.email.isNotEmpty)
                          SelectableText('${room.email}@fun.ac.jp'),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                const Text('Googleアカウント (@fun.ac.jp) でログインして詳細を確認'),
                DottoButton(
                  onPressed: onGoToSettingButtonTapped,
                  type: DottoButtonType.text,
                  child: const Text('設定に移動する'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
