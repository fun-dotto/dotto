import 'package:collection/collection.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/domain/room_equipment.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class MapDetailBottomSheet extends StatelessWidget {
  const MapDetailBottomSheet({
    required this.props,
    required this.room,
    required this.dateTime,
    required this.isLoggedIn,
    required this.onDismissed,
    required this.onGoToSettingButtonTapped,
    super.key,
  });

  final MapTileProps props;
  final Room room;
  final DateTime dateTime;
  final bool isLoggedIn;
  final void Function() onDismissed;
  final void Function() onGoToSettingButtonTapped;

  DateTime get startOfDay => DateTime(dateTime.year, dateTime.month, dateTime.day);
  DateTime get endOfDay => DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999);

  static const Color blue = Color(0xFF4A90E2);

  Widget scheduleTile(BuildContext context, DateTime begin, DateTime end, String title) {
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(overflow: TextOverflow.ellipsis),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(DateFormat('MM/dd').format(begin), style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(width: 5),
              Text(
                '${DateFormat('HH:mm').format(begin)} - '
                '${DateFormat('HH:mm').format(end)}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          // time
        ],
      ),
    );
  }

  Widget roomEquipment(BuildContext context, RoomEquipment equipment) {
    final fontColor = SemanticColor.light.labelTertiary;
    return Container(
      width: 140,
      decoration: BoxDecoration(color: blue.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(equipment.icon, color: fontColor, size: 20),
          Text(equipment.label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fontColor)),
          Icon(equipment.quality.icon, color: fontColor, size: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: SelectableText(room.name, style: Theme.of(context).textTheme.titleMedium)),
              IconButton(onPressed: onDismissed, icon: const Icon(Icons.close)),
            ],
          ),
          if (isLoggedIn)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 8,
                      children: [
                        if (props is ClassroomMapTileProps) ...[
                          roomEquipment(context, (props as ClassroomMapTileProps).equipment.food),
                          roomEquipment(context, (props as ClassroomMapTileProps).equipment.drink),
                          roomEquipment(context, (props as ClassroomMapTileProps).equipment.outlet),
                        ],
                        if (props is SubRoomMapTileProps && (props as SubRoomMapTileProps).equipment != null) ...[
                          roomEquipment(context, (props as SubRoomMapTileProps).equipment!.food),
                          roomEquipment(context, (props as SubRoomMapTileProps).equipment!.drink),
                          roomEquipment(context, (props as SubRoomMapTileProps).equipment!.outlet),
                        ],
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (room.schedules.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: room.schedules
                                .where((e) => e.beginDatetime.isAfter(startOfDay) && e.endDatetime.isBefore(endOfDay))
                                .sorted((a, b) => a.beginDatetime.compareTo(b.beginDatetime))
                                .map((e) => scheduleTile(context, e.beginDatetime, e.endDatetime, e.title))
                                .toList(),
                          )
                        else if (room.description.isNotEmpty)
                          SelectableText(room.description),
                        if (room.email.isNotEmpty) SelectableText('${room.email}@fun.ac.jp'),
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
