import 'package:dotto/api/firebase/room_schedule_response.dart';

final class MapDetail {
  const MapDetail(
    this.floor,
    this.roomName,
    this.classroomNo,
    this.header,
    this.detail,
    this.mail,
    this.searchWordList, {
    this.scheduleList,
  });

  factory MapDetail.fromFirebase(
    String floor,
    String roomName,
    Map<String, dynamic> value,
    Map<String, dynamic> roomScheduleMap,
  ) {
    List<String>? sWordList;
    if (value.containsKey('searchWordList')) {
      final searchWordRaw = value['searchWordList'];
      if (searchWordRaw is String) {
        sWordList = searchWordRaw.split(',');
      } else if (searchWordRaw is List) {
        sWordList = searchWordRaw.map((e) => e.toString()).toList();
      }
    }

    List<RoomScheduleResponse>? roomScheduleList;
    if (roomScheduleMap.containsKey(roomName)) {
      final scheduleRaw = roomScheduleMap[roomName];

      Iterable<Map<String, dynamic>> scheduleIterable =
          const <Map<String, dynamic>>[];
      if (scheduleRaw is List) {
        scheduleIterable = scheduleRaw.whereType<Map<dynamic, dynamic>>().map(
          (e) => e.map((key, value) => MapEntry(key.toString(), value)),
        );
      } else if (scheduleRaw is Map) {
        scheduleIterable = scheduleRaw.values
            .whereType<Map<dynamic, dynamic>>()
            .map((e) => e.map((key, value) => MapEntry(key.toString(), value)));
      }

      final list = scheduleIterable.map(RoomScheduleResponse.fromJson).toList()
        ..sort((a, b) => a.beginDatetime.compareTo(b.beginDatetime));
      roomScheduleList = list.isEmpty ? null : list;
    }

    final classroomNoRaw = value['classroomNo'];
    final classroomNo = classroomNoRaw is int
        ? classroomNoRaw
        : int.tryParse(classroomNoRaw?.toString() ?? '');

    return MapDetail(
      floor,
      roomName,
      classroomNo,
      value['header']?.toString() ?? '',
      value['detail']?.toString(),
      value['mail']?.toString(),
      sWordList,
      scheduleList: roomScheduleList,
    );
  }

  final String floor;
  final String roomName;
  final int? classroomNo;
  final String header;
  final String? detail;
  final List<RoomScheduleResponse>? scheduleList;
  final String? mail;
  final List<String>? searchWordList;

  static const MapDetail none = MapDetail(
    '1',
    '0',
    null,
    '0',
    null,
    null,
    null,
  );

  List<RoomScheduleResponse> getScheduleListByDate(DateTime dateTime) {
    final list = scheduleList;
    if (list == null) {
      return [];
    }
    final targetDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final targetTomorrowDay = targetDay.add(const Duration(days: 1));
    return list
        .where(
          (roomSchedule) =>
              roomSchedule.beginDatetime.isBefore(targetTomorrowDay) &&
              roomSchedule.endDatetime.isAfter(targetDay),
        )
        .toList();
  }
}
