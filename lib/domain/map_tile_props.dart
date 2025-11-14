import 'package:dotto/domain/restroom_type.dart';

class MapTileProps {
  MapTileProps({
    required this.width,
    required this.height,
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
  });

  final int width;
  final int height;
  final double top;
  final double right;
  final double bottom;
  final double left;
}

final class ClassroomMapTileProps extends MapTileProps {
  ClassroomMapTileProps({
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

final class FacultyRoomMapTileProps extends MapTileProps {
  FacultyRoomMapTileProps({
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

final class RestroomMapTileProps extends MapTileProps {
  RestroomMapTileProps({
    required super.width,
    required super.height,
    required super.top,
    required super.right,
    required super.bottom,
    required super.left,
    required this.type,
  });

  final RestroomType type;
}

final class StairMapTileProps extends MapTileProps {
  StairMapTileProps({
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
    required super.width,
    required super.height,
    required super.top,
    required super.right,
    required super.bottom,
    required super.left,
  });
}
