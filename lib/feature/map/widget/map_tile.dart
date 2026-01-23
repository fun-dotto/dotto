import 'package:dotto/domain/map_colors.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/domain/room.dart';
import 'package:flutter/material.dart';

final class MapTile extends StatelessWidget {
  const MapTile({
    required this.props,
    required this.isFocused,
    required this.dateTime,
    this.room,
    this.onTapped,
    super.key,
  });

  final MapTileProps props;
  final Room? room;
  final bool isFocused;
  final DateTime dateTime;
  final void Function(MapTileProps, Room?)? onTapped;

  Color get tileColor {
    return isFocused
        ? MapColors.focusedTile
        : room?.isInUse(dateTime) ?? false
        ? MapColors.roomInUseTile
        : props.backgroundColor;
  }

  Color get labelColor {
    return isFocused
        ? Colors.white
        : room?.isInUse(dateTime) ?? false
        ? Colors.black
        : props.foregroundColor;
  }

  String get labelText => room?.shortName ?? props.label ?? '';

  double get fontSize {
    if (props.width == 1) return 3;
    if (props.width >= 6 && labelText.length <= 4) return 8;
    if (props.width >= 6) return 6;
    return 4;
  }

  double get iconSize {
    final length = (props is RestroomMapTileProps
        ? (props as RestroomMapTileProps).types.length
        : 0);
    if (props.width == 1) return 6;
    if (props.width * props.height / length <= 2) return 6;
    return 8;
  }

  EdgeInsets get padding {
    return EdgeInsets.only(
      top: (props.top > 0 || isFocused) ? 0 : 1,
      right: (props.right > 0 || isFocused) ? 0 : 1,
      bottom: (props.bottom > 0 || isFocused) ? 0 : 1,
      left: (props.left > 0 || isFocused) ? 0 : 1,
    );
  }

  Border get border {
    return Border(
      top: isFocused
          ? const BorderSide(color: MapColors.focusedTile)
          : props.top > 0
          ? BorderSide(width: props.top.toDouble())
          : BorderSide.none,
      right: isFocused
          ? const BorderSide(color: MapColors.focusedTile)
          : props.right > 0
          ? BorderSide(width: props.right.toDouble())
          : BorderSide.none,
      bottom: isFocused
          ? const BorderSide(color: MapColors.focusedTile)
          : props.bottom > 0
          ? BorderSide(width: props.bottom.toDouble())
          : BorderSide.none,
      left: isFocused
          ? const BorderSide(color: MapColors.focusedTile)
          : props.left > 0
          ? BorderSide(width: props.left.toDouble())
          : BorderSide.none,
    );
  }

  Widget get tile {
    return SizedBox.expand(
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: (props is AtriumMapTileProps)
              ? tileColor
              : MapColors.aisleTile,
        ),
        child: SizedBox.expand(
          child: Container(padding: EdgeInsets.zero, color: tileColor),
        ),
      ),
    );
  }

  Widget _label(BuildContext context) {
    return Text(
      labelText,
      style: Theme.of(
        context,
      ).textTheme.labelSmall?.copyWith(fontSize: fontSize, color: labelColor),
    );
  }

  Widget get restroomIcons {
    return Wrap(
      children: (props as RestroomMapTileProps).types
          .map((type) => Icon(type.icon, size: iconSize, color: type.color))
          .toList(),
    );
  }

  Widget get stair {
    final stairWidth = props.width * 2.5;
    final stairHeight = props.height * 2.5;
    return Stack(
      children: [
        SizedBox.expand(
          child: Flex(
            direction: (props as StairMapTileProps).type.getDirection(),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if ((props as StairMapTileProps).type.direction ==
                  Axis.horizontal)
                for (int i = 0; i < stairWidth.toInt(); i++) ...{
                  const Expanded(
                    child: VerticalDivider(thickness: 0.3, color: Colors.black),
                  ),
                }
              else
                for (int i = 0; i < stairHeight.toInt(); i++) ...{
                  const Expanded(
                    child: Divider(thickness: 0.3, color: Colors.black),
                  ),
                },
            ],
          ),
        ),
        if ((props as StairMapTileProps).type.up &&
            !(props as StairMapTileProps).type.down)
          SizedBox.expand(
            child: Center(
              child: Icon(
                Icons.arrow_upward_rounded,
                size: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        if (!(props as StairMapTileProps).type.up &&
            ((props as StairMapTileProps).type.down))
          SizedBox.expand(
            child: Center(
              child: Icon(
                Icons.arrow_downward_rounded,
                size: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        if (((props as StairMapTileProps).type.up) &&
            ((props as StairMapTileProps).type.down))
          const SizedBox.expand(),
      ],
    );
  }

  Widget get elevator {
    return const Icon(
      Icons.elevator_outlined,
      size: 12,
      color: Colors.white,
      weight: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapped?.call(props, room),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          tile,
          Padding(padding: const EdgeInsets.all(2), child: _label(context)),
          if (props is RestroomMapTileProps) restroomIcons,
          if (props is StairMapTileProps) stair,
          if (props is ElevatorMapTileProps) elevator,
        ],
      ),
    );
  }
}
