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
    final data = snapshot.value! as Map<String, dynamic>;
    return data.map((floor, floorRooms) {
      final floorRoomsMap = floorRooms as Map<String, dynamic>;
      return MapEntry(
        floor,
        floorRoomsMap.map((roomId, room) {
          final roomMap = room as Map<String, dynamic>;
          final roomResponse = RoomResponse.fromJson(roomMap);
          return MapEntry(roomId, roomResponse);
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
    final data = snapshot.value! as Map<String, dynamic>;
    return data.map((roomId, roomSchedules) {
      final roomSchedulesMap = roomSchedules as Map<String, dynamic>;
      return MapEntry(
        roomId,
        roomSchedulesMap.values.map((roomSchedule) {
          final roomScheduleMap = roomSchedule as Map<String, dynamic>;
          final roomScheduleResponse = RoomScheduleResponse.fromJson(
            roomScheduleMap,
          );
          return roomScheduleResponse;
        }).toList(),
      );
    });
  }
}
