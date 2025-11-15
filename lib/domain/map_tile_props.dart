import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/map_stair_type.dart';
import 'package:dotto/domain/restroom_type.dart';
import 'package:dotto/domain/room_equipment.dart';
import 'package:flutter/material.dart';

abstract class MapTileProps {
  MapTileProps({
    required this.floor,
    required this.width,
    required this.height,
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
    this.id,
    this.label,
  });

  final Floor floor;

  final int width;
  final int height;
  final int top;
  final int right;
  final int bottom;
  final int left;

  final String? id;
  final String? label;

  Color get foregroundColor => Colors.black;
  Color get backgroundColor => Colors.transparent;
}

final class ClassroomMapTileProps extends MapTileProps {
  ClassroomMapTileProps({
    required super.floor,
    required super.width,
    required super.height,
    required super.top,
    required super.right,
    required super.bottom,
    required super.left,
    required this.equipment,
    super.id,
    super.label,
  });

  final RoomEquipmentStatus equipment;

  @override
  Color get foregroundColor => Colors.white;
  @override
  Color get backgroundColor => const Color(0xFF616161);
}

final class FacultyRoomMapTileProps extends MapTileProps {
  FacultyRoomMapTileProps({
    required super.floor,
    required super.width,
    required super.height,
    required super.top,
    required super.right,
    required super.bottom,
    required super.left,
    super.id,
    super.label,
  });

  @override
  Color get foregroundColor => Colors.white;
  @override
  Color get backgroundColor => const Color(0xFF757575);
}

final class SubRoomMapTileProps extends MapTileProps {
  SubRoomMapTileProps({
    required super.floor,
    required super.width,
    required super.height,
    required super.top,
    required super.right,
    required super.bottom,
    required super.left,
    super.id,
    super.label,
  });

  @override
  Color get foregroundColor => Colors.black;
  @override
  Color get backgroundColor => Colors.grey;
}

final class OtherRoomMapTileProps extends MapTileProps {
  OtherRoomMapTileProps({
    required super.floor,
    required super.width,
    required super.height,
    required super.top,
    required super.right,
    required super.bottom,
    required super.left,
    super.id,
    super.label,
  });

  @override
  Color get foregroundColor => Colors.black;
  @override
  Color get backgroundColor => const Color(0xFFBDBDBD);
}

final class RestroomMapTileProps extends MapTileProps {
  RestroomMapTileProps({
    required super.floor,
    required super.width,
    required super.height,
    required super.top,
    required super.right,
    required super.bottom,
    required super.left,
    required this.types,
  });

  final List<RestroomType> types;

  @override
  Color get foregroundColor => Colors.black;
  @override
  Color get backgroundColor => const Color(0xFF9CCC65);
}

final class StairMapTileProps extends MapTileProps {
  StairMapTileProps({
    required super.floor,
    required super.width,
    required super.height,
    required super.top,
    required super.right,
    required super.bottom,
    required super.left,
    required this.type,
  });

  final MapStairType type;

  @override
  Color get foregroundColor => Colors.black;
  @override
  Color get backgroundColor => const Color(0xFFE0E0E0);
}

final class ElevatorMapTileProps extends MapTileProps {
  ElevatorMapTileProps({
    required super.floor,
    required super.width,
    required super.height,
    required super.top,
    required super.right,
    required super.bottom,
    required super.left,
  });

  @override
  Color get foregroundColor => Colors.white;
  @override
  Color get backgroundColor => const Color(0xFF424242);
}

final class AisleMapTileProps extends MapTileProps {
  AisleMapTileProps({
    required super.floor,
    required super.width,
    required super.height,
    required super.top,
    required super.right,
    required super.bottom,
    required super.left,
    super.label,
  });

  @override
  Color get foregroundColor => Colors.black;
  @override
  Color get backgroundColor => const Color(0xFFE0E0E0);
}

final class AtriumMapTileProps extends MapTileProps {
  AtriumMapTileProps({
    required super.floor,
    required super.width,
    required super.height,
    required super.top,
    required super.right,
    required super.bottom,
    required super.left,
  });

  @override
  Color get foregroundColor => Colors.black;
  @override
  Color get backgroundColor => Colors.transparent;
}
