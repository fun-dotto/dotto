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

    List<RoomSchedule>? roomScheduleList;
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

      final list = scheduleIterable.map(RoomSchedule.fromFirebase).toList()
        ..sort((a, b) => a.begin.compareTo(b.begin));
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
  final List<RoomSchedule>? scheduleList;
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

  List<RoomSchedule> getScheduleListByDate(DateTime dateTime) {
    final list = scheduleList;
    if (list == null) {
      return [];
    }
    final targetDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final targetTomorrowDay = targetDay.add(const Duration(days: 1));
    return list
        .where(
          (roomSchedule) =>
              roomSchedule.begin.isBefore(targetTomorrowDay) &&
              roomSchedule.end.isAfter(targetDay),
        )
        .toList();
  }
}

final class RoomSchedule {
  const RoomSchedule(this.begin, this.end, this.title);

  factory RoomSchedule.fromFirebase(Map<String, dynamic> map) {
    final beginDatetime = DateTime.parse(map['begin_datetime'] as String);
    final endDatetime = DateTime.parse(map['end_datetime'] as String);
    final title = map['title'];
    return RoomSchedule(beginDatetime, endDatetime, title as String);
  }
  final DateTime begin;
  final DateTime end;
  final String title;
}

final class MapDetailMap {
  MapDetailMap(this.mapDetailList);
  final Map<String, Map<String, MapDetail>> mapDetailList;

  MapDetail? searchOnce(String floor, String roomName) {
    if (mapDetailList.containsKey(floor)) {
      if (mapDetailList[floor]!.containsKey(roomName)) {
        return mapDetailList[floor]![roomName]!;
      }
    }
    return null;
  }

  List<MapDetail> searchAll(String searchText) {
    final results = <MapDetail>[];
    final results2 = <MapDetail>[];
    final results3 = <MapDetail>[];
    final results4 = <MapDetail>[];
    mapDetailList.forEach((_, value) {
      for (final mapDetail in value.values) {
        if (mapDetail.roomName == searchText) {
          results.add(mapDetail);
          continue;
        }
        if (mapDetail.searchWordList != null) {
          var matchFlag = false;
          for (final word in mapDetail.searchWordList!) {
            if (word.contains(searchText)) {
              results2.add(mapDetail);
              matchFlag = true;
              break;
            }
          }
          if (matchFlag) continue;
        }
        if (mapDetail.header.contains(searchText)) {
          results3.add(mapDetail);
          continue;
        }
        if (mapDetail.mail != null) {
          if (mapDetail.mail!.contains(searchText)) {
            results3.add(mapDetail);
            continue;
          }
        }
        if (mapDetail.detail != null) {
          if (mapDetail.detail!.contains(searchText)) {
            results4.add(mapDetail);
            continue;
          }
        }
      }
    });
    return [...results, ...results2, ...results3, ...results4];
  }
}
