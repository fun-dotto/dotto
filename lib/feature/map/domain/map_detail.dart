final class MapDetail {
  const MapDetail(this.floor, this.roomName, this.classroomNo, this.header,
      this.detail, this.mail, this.searchWordList,
      {this.scheduleList});

  factory MapDetail.fromFirebase(
      String floor, String roomName, Map value, Map roomScheduleMap) {
    List<String>? sWordList;
    if (value.containsKey('searchWordList')) {
      sWordList = (value['searchWordList'] as String).split(',');
    }
    List<RoomSchedule>? roomScheduleList;
    if (roomScheduleMap.containsKey(roomName)) {
      final scheduleList = roomScheduleMap[roomName] as List;
      roomScheduleList = scheduleList.map((e) {
        return RoomSchedule.fromFirebase(e as Map);
      }).toList();
      roomScheduleList.sort(
        (a, b) {
          return a.begin.compareTo(b.begin);
        },
      );
    }
    return MapDetail(
        floor as String,
        roomName as String,
        value['classroomNo'] as int?,
        value['header'] as String,
        value['detail'] as String?,
        value['mail'] as String?,
        sWordList,
        scheduleList: roomScheduleList);
  }
  final String floor;
  final String roomName;
  final int? classroomNo;
  final String header;
  final String? detail;
  final List<RoomSchedule>? scheduleList;
  final String? mail;
  final List<String>? searchWordList;

  static const MapDetail none =
      MapDetail('1', '0', null, '0', null, null, null);

  List<RoomSchedule> getScheduleListByDate(DateTime dateTime) {
    final list = scheduleList;
    if (list == null) {
      return [];
    }
    final targetDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final targetTomorrowDay = targetDay.add(const Duration(days: 1));
    return list
        .where((roomSchedule) =>
            roomSchedule.begin.isBefore(targetTomorrowDay) &&
            roomSchedule.end.isAfter(targetDay))
        .toList();
  }
}

final class RoomSchedule {
  const RoomSchedule(this.begin, this.end, this.title);

  factory RoomSchedule.fromFirebase(Map map) {
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
