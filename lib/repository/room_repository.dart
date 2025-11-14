import 'package:dotto/api/firebase/room_api.dart';
import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/domain/room_schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomRepositoryProvider = Provider<RoomRepository>(
  (_) => _RoomRepositoryImpl(),
);

abstract class RoomRepository {
  Future<List<Room>> getRooms();
}

final class _RoomRepositoryImpl implements RoomRepository {
  @override
  Future<List<Room>> getRooms() async {
    final roomResponses = await RoomAPI.getRooms();
    final roomScheduleResponses = await RoomAPI.getRoomSchedules();

    return roomResponses.entries.expand((floorEntry) {
      final floorLabel = floorEntry.key;
      final roomsMap = floorEntry.value;
      final floor = Floor.fromLabel(floorLabel);

      return roomsMap.entries.map((roomEntry) {
        final roomId = roomEntry.key;
        final roomResponse = roomEntry.value;

        final schedules = (roomScheduleResponses[roomId] ?? [])
            .map(
              (scheduleResponse) => RoomSchedule(
                beginDatetime: scheduleResponse.beginDatetime,
                endDatetime: scheduleResponse.endDatetime,
                title: scheduleResponse.title,
              ),
            )
            .toList();

        return Room(
          id: roomId,
          name: roomResponse.header,
          description: roomResponse.detail ?? '',
          floor: floor,
          email: roomResponse.mail ?? '',
          keywords: roomResponse.searchWordList ?? [],
          schedules: schedules,
        );
      });
    }).toList();
  }
}
