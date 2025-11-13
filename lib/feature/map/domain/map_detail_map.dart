import 'package:dotto/feature/map/domain/room.dart';

final class MapDetailMap {
  MapDetailMap(this.mapDetailList);
  final Map<String, Map<String, Room>> mapDetailList;

  Room? searchOnce(String floor, String roomName) {
    if (mapDetailList.containsKey(floor)) {
      if (mapDetailList[floor]!.containsKey(roomName)) {
        return mapDetailList[floor]![roomName]!;
      }
    }
    return null;
  }

  List<Room> searchAll(String searchText) {
    final results = <Room>[];
    final results2 = <Room>[];
    final results3 = <Room>[];
    final results4 = <Room>[];
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
