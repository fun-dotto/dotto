import 'dart:convert';

import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/repository/firebase_realtime_database_repository.dart';
import 'package:dotto/repository/read_json_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapRepository {
  factory MapRepository() {
    return _instance;
  }
  MapRepository._internal();
  static final MapRepository _instance = MapRepository._internal();

  Future<Map<String, Map<String, MapDetail>>>
  getMapDetailMapFromFirebase() async {
    final snapshot = await FirebaseRealtimeDatabaseRepository().getData(
      'map',
    ); //firebaseから情報取得
    final snapshotRoom = await FirebaseRealtimeDatabaseRepository().getData(
      'map_room_schedule',
    ); //firebaseから情報取得
    final returnList = <String, Map<String, MapDetail>>{
      '1': {},
      '2': {},
      '3': {},
      '4': {},
      '5': {},
      'R6': {},
      'R7': {},
    };
    if (snapshot.exists && snapshotRoom.exists) {
      final mapData = snapshot.value! as Map;
      final roomScheduleMap = (snapshotRoom.value! as Map).map(
        (key, value) => MapEntry(key.toString(), value),
      );
      mapData.forEach((floor, value) {
        final floorKey = floor.toString();
        final roomMap = returnList.putIfAbsent(
          floorKey,
          () => <String, MapDetail>{},
        );
        (value as Map).forEach((roomName, value2) {
          final roomKey = roomName.toString();
          roomMap[roomKey] = MapDetail.fromFirebase(
            floorKey,
            roomKey,
            (value2 as Map).map(
              (key, value) => MapEntry(key.toString(), value),
            ),
            roomScheduleMap,
          );
        });
      });
    } else {
      debugPrint('No Map data available.');
      throw Exception('No Map data available.');
    }
    return returnList;
  }

  Map<String, DateTime> findRoomsInUse(String jsonString, DateTime dateTime) {
    final decodedData = jsonDecode(jsonString);

    // JSONデータがリストでない場合はエラー
    if (decodedData is! List) {
      throw Exception('Expected a list of JSON objects');
    }

    final resourceIds = <String, DateTime>{};

    for (final item in decodedData) {
      if (item is Map<String, dynamic>) {
        // スタート時間・エンド時間をDateTimeにかえる
        // スタートを10分前から
        final startTime = DateTime.parse(
          item['start'] as String,
        ).add(const Duration(minutes: -10));
        final endTime = DateTime.parse(item['end'] as String);

        //現在時刻が開始時刻と終了時刻の間であればresourceIdを取得
        if (dateTime.isAfter(startTime) && dateTime.isBefore(endTime)) {
          if (resourceIds.containsKey(item['resourceId'])) {
            if (resourceIds[item['resourceId']]!.isBefore(endTime)) {
              resourceIds[item['resourceId'] as String] = endTime;
            }
          } else {
            resourceIds.addAll({item['resourceId'] as String: endTime});
          }
        }
      }
    }

    return resourceIds;
  }

  Future<Map<String, DateTime>> getUsingRoom(DateTime dateTime) async {
    const scheduleFilePath = 'map/oneweek_schedule.json';
    var resourceIds = <String, DateTime>{};
    try {
      final fileContent = await readJsonFile(scheduleFilePath);
      resourceIds = findRoomsInUse(fileContent, dateTime);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    return resourceIds;
  }

  //使用されているかどうかで色を変える設定をする
  Future<Map<String, bool>> setUsingColor(
    DateTime dateTime,
    WidgetRef ref,
  ) async {
    final user = ref.watch(userProvider);
    if (user == null) {
      return {};
    }
    final classroomNoFloorMap = <String, bool>{
      '1': false,
      '2': false,
      '3': false,
      '4': false,
      '5': false,
      '6': false,
      '7': false,
      '8': false,
      '9': false,
      '10': false,
      '11': false,
      '12': false,
      '13': false,
      '14': false,
      '15': false,
      '16': false,
      '17': false,
      '18': false,
      '19': false,
      '50': false,
      '51': false,
    };

    final resourceIds = await MapRepository().getUsingRoom(dateTime);
    if (resourceIds.isNotEmpty) {
      resourceIds.forEach((String resourceId, DateTime useEndTime) {
        if (classroomNoFloorMap.containsKey(resourceId)) {
          classroomNoFloorMap[resourceId] = true;
        }
      });
    }
    return classroomNoFloorMap;
  }
}
