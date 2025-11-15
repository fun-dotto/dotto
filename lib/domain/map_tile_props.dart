import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/restroom_type.dart';
import 'package:dotto/domain/room_equipment.dart';

class MapTileProps {
  MapTileProps({
    required this.floor,
    required this.width,
    required this.height,
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
  });

  final Floor floor;

  final int width;
  final int height;
  final int top;
  final int right;
  final int bottom;
  final int left;
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
    required this.id,
    required this.equipments,
  });

  final String id;
  final List<RoomEquipment> equipments;
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
    required this.id,
  });

  final String id;
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
    required this.id,
  });

  final String id;
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
    this.label,
  });

  final String? label;
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
  });
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
  });
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
}
