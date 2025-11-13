import 'package:dotto/api/firebase/room_response.dart';
import 'package:dotto/api/firebase/room_schedule_response.dart';
import 'package:dotto/repository/firebase_realtime_database_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomApiProvider = Provider<RoomApi>((_) => _RoomApiImpl());

abstract class RoomApi {
  Future<Map<String /* floor */, Map<String /* roomId */, RoomResponse>>>
  getRooms();
  Future<Map<String /* roomId */, List<RoomScheduleResponse>>>
  getRoomSchedules();
}

final class _RoomApiImpl implements RoomApi {
  @override
  Future<Map<String, Map<String, RoomResponse>>> getRooms() async {
    final snapshot = await FirebaseRealtimeDatabaseRepository().getData('map');
    if (!snapshot.exists) {
      throw Exception('No data available');
    }
    final data = snapshot.value! as Map<Object?, Object?>;
    return data.map((floor, floorRooms) {
      if (floor == null) {
        return const MapEntry('', {});
      }
      if (floorRooms == null) {
        return MapEntry(floor.toString(), {});
      }
      final floorRoomsMap = floorRooms as Map<Object?, Object?>;
      return MapEntry(
        floor.toString(),
        floorRoomsMap.map((roomId, room) {
          if (room == null) {
            return MapEntry(roomId.toString(), RoomResponse.fromJson({}));
          }
          final roomMap = room as Map<Object?, Object?>;
          final roomResponse = RoomResponse.fromJson(
            roomMap.map((key, value) => MapEntry(key.toString(), value)),
          );
          return MapEntry(roomId.toString(), roomResponse);
        }),
      );
    });
  }

  @override
  Future<Map<String, List<RoomScheduleResponse>>> getRoomSchedules() async {
    final snapshot = await FirebaseRealtimeDatabaseRepository().getData(
      'map_room_schedule',
    );
    if (!snapshot.exists) {
      throw Exception('No data available');
    }
    final data = snapshot.value! as Map<Object?, Object?>;
    return data.map((roomId, roomSchedules) {
      if (roomId == null) {
        return const MapEntry('', []);
      }
      if (roomSchedules == null) {
        return MapEntry(roomId.toString(), []);
      }
      final roomScheduleList = roomSchedules as List<Object?>;
      return MapEntry(
        roomId.toString(),
        roomScheduleList.map((roomSchedule) {
          if (roomSchedule == null) {
            return RoomScheduleResponse.fromJson({});
          }
          final roomScheduleMap = roomSchedule as Map<Object?, Object?>;
          final roomScheduleResponse = RoomScheduleResponse.fromJson(
            roomScheduleMap.map(
              (key, value) => MapEntry(key.toString(), value),
            ),
          );
          return roomScheduleResponse;
        }).toList(),
      );
    });
  }
}
