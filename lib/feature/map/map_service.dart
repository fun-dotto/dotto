import 'package:dotto/api/firebase/room_api.dart';
import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/domain/room_schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapService {
  MapService({required this.ref});
  final Ref ref;

  Future<List<Room>> getRooms() async {
    final roomsResponse = await ref.read(roomApiProvider).getRooms();
    final roomSchedulesResponse = await ref
        .read(roomApiProvider)
        .getRoomSchedules();
    final rooms = roomsResponse.entries.map((entry) {
      final floor = entry.key;
      final rooms = entry.value;
      return rooms.entries.map((roomEntry) {
        final roomId = roomEntry.key;
        final room = roomEntry.value;
        final roomSchedules = roomSchedulesResponse[roomId] ?? [];
        return Room(
          id: roomId,
          name: room.header,
          description: room.detail ?? '',
          floor: Floor.fromLabel(floor),
          email: room.mail ?? '',
          keywords: room.searchWordList ?? [],
          schedules: roomSchedules.map((roomSchedule) {
            return RoomSchedule(
              beginDatetime: roomSchedule.beginDatetime,
              endDatetime: roomSchedule.endDatetime,
              title: roomSchedule.title,
            );
          }).toList(),
        );
      }).toList();
    }).toList();
    return rooms.expand((room) => room).toList();
  }
}
