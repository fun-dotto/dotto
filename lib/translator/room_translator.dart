import 'package:dotto/api/firebase/room_response.dart';
import 'package:dotto/api/firebase/room_schedule_response.dart';
import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/domain/room_schedule.dart';

final class RoomTranslator {
  const RoomTranslator();

  List<Room> translate(
    Map<String, Map<String, RoomResponse>> roomResponses,
    Map<String, List<RoomScheduleResponse>> roomScheduleResponses,
  ) {
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
