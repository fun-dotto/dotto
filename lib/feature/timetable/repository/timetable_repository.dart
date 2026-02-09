import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/search_course/repository/syllabus_database_config.dart';
import 'package:dotto/feature/timetable/controller/personal_lesson_id_list_controller.dart';
import 'package:dotto/feature/timetable/controller/week_period_all_records_controller.dart';
import 'package:dotto/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/helper/read_json_file.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

/// 時間割データの取得・管理を行うリポジトリクラス
final class TimetableRepository {
  /// ファクトリーコンストラクタ
  factory TimetableRepository() {
    return _instance;
  }

  TimetableRepository._internal();

  /// シングルトンインスタンス
  static final TimetableRepository _instance = TimetableRepository._internal();

  /// Firestore インスタンス
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// 月曜から次の週の日曜までの日付を返す
  List<DateTime> getDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // 月曜
    final startDate = today.subtract(Duration(days: today.weekday - 1));

    final dates = <DateTime>[];
    for (var i = 0; i < 14; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }

    return dates;
  }

  /// 指定された授業IDでデータベースから授業情報を取得する
  Future<Map<String, dynamic>?> fetchDB(int lessonId) async {
    final dbPath = await SyllabusDatabaseConfig().getDBPath();
    final database = await openDatabase(dbPath);

    final records = await database.rawQuery('SELECT LessonId, 過去問, 授業名 FROM sort where LessonId = ?', [lessonId]);
    if (records.isEmpty) {
      return null;
    }
    return records.first;
  }

  Future<List<String>> getLessonNameList(List<int> lessonIdList) async {
    final dbPath = await SyllabusDatabaseConfig().getDBPath();
    final database = await openDatabase(dbPath);

    final List<Map<String, dynamic>> records = await database.rawQuery(
      'SELECT 授業名 FROM sort WHERE LessonId in (${lessonIdList.join(",")})',
    );
    final lessonNameList = records.map((e) => e['授業名'] as String).toList();
    return lessonNameList;
  }

  Future<List<int>> _getPersonalTimetableList() async {
    final jsonString = await UserPreferenceRepository.getString(UserPreferenceKeys.personalTimetableListKey);
    if (jsonString != null) {
      return List<int>.from(json.decode(jsonString) as List);
    }
    return [];
  }

  Future<void> loadPersonalTimetableListOnLogin(BuildContext context, WidgetRef ref) async {
    final user = ref.read(userProvider);
    if (user == null) {
      return;
    }
    var personalTimetableList = <int>[];
    final doc = db.collection('user_taking_course').doc(user.uid);
    final docSnapshot = await doc.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        final firestoreLastUpdated = data['last_updated'] as Timestamp;
        final localLastUpdated =
            await UserPreferenceRepository.getInt(UserPreferenceKeys.personalTimetableLastUpdateKey) ?? 0;
        final diff = localLastUpdated - firestoreLastUpdated.millisecondsSinceEpoch;
        final firestoreList = List<int>.from(data['2025'] as List);
        final localList = await _getPersonalTimetableList();
        if (localList.isEmpty) {
          personalTimetableList = firestoreList;
        } else if (firestoreList.isEmpty) {
          personalTimetableList = localList;
          await savePersonalTimetableListToFirestore(personalTimetableList, ref);
        } else if (diff.abs() > 300000) {
          final firestoreSet = firestoreList.toSet();
          final localSet = localList.toSet();
          // firestoreList と locallist のIDが同じかどうか確認
          if (firestoreSet.containsAll(localSet) && localSet.containsAll(firestoreSet)) {
            personalTimetableList = firestoreList;
          } else {
            // LessonName取得
            final firestoreLessonNameList = await getLessonNameList(firestoreSet.difference(localSet).toList());
            final localLessonNameList = await getLessonNameList(localSet.difference(firestoreSet).toList());
            if (context.mounted) {
              await showDialog<void>(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('データの同期'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'アカウントに紐づいている時間割とローカルの時間割が'
                            '異なっています。どちらを残しますか？',
                          ),
                          const Text('-- アカウント側に多い科目 --'),
                          ...firestoreLessonNameList.map(Text.new),
                          const SizedBox(height: 10),
                          const Text('-- ローカル側に多い科目 --'),
                          ...localLessonNameList.map(Text.new),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          personalTimetableList = firestoreList;
                          Navigator.of(context).pop();
                        },
                        child: const Text('アカウント方を残す'),
                      ),
                      TextButton(
                        onPressed: () async {
                          personalTimetableList = localList;
                          await savePersonalTimetableListToFirestore(personalTimetableList, ref);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('ローカル方を残す'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        } else {
          personalTimetableList = firestoreList;
        }
      } else {
        personalTimetableList = await _getPersonalTimetableList();
        await savePersonalTimetableListToFirestore(personalTimetableList, ref);
      }
    } else {
      personalTimetableList = await _getPersonalTimetableList();
      await savePersonalTimetableListToFirestore(personalTimetableList, ref);
    }
  }

  Future<List<int>> loadPersonalTimetableList(WidgetRef ref) async {
    final user = ref.read(userProvider);
    var personalTimetableList = <int>[];
    if (user == null) {
      personalTimetableList = await _getPersonalTimetableList();
    } else {
      final doc = db.collection('user_taking_course').doc(user.uid);
      final docSnapshot = await doc.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          final firestoreLastUpdated = data['last_updated'] as Timestamp;
          final localLastUpdated =
              await UserPreferenceRepository.getInt(UserPreferenceKeys.personalTimetableLastUpdateKey) ?? 0;
          final diff = localLastUpdated - firestoreLastUpdated.millisecondsSinceEpoch;
          final firestoreList = List<int>.from(data['2025'] as List);
          final localList = await _getPersonalTimetableList();
          // ここなぜか取得できない
          if (localList.isEmpty) {
            personalTimetableList = firestoreList;
          } else if (firestoreList.isEmpty || diff > 600000) {
            personalTimetableList = localList;
            await savePersonalTimetableListToFirestore(personalTimetableList, ref);
          } else {
            personalTimetableList = firestoreList;
          }
        } else {
          personalTimetableList = await _getPersonalTimetableList();
          await savePersonalTimetableListToFirestore(personalTimetableList, ref);
        }
      } else {
        personalTimetableList = await _getPersonalTimetableList();
        await savePersonalTimetableListToFirestore(personalTimetableList, ref);
      }
    }
    await savePersonalTimetableList(personalTimetableList, ref);
    return personalTimetableList;
  }

  Future<void> addPersonalTimetableListToFirestore(int lessonId, WidgetRef ref) async {
    final user = ref.read(userProvider);
    if (user == null) {
      return;
    }
    final doc = db.collection('user_taking_course').doc(user.uid);
    await doc.update({
      '2025': FieldValue.arrayUnion([lessonId]),
      'last_updated': FieldValue.serverTimestamp(),
    });
    // .onError((error, stackTrace) async {
    //   await savePersonalTimetableListToFirestore(ref);
    // });
  }

  Future<void> removePersonalTimetableListFromFirestore(int lessonId, WidgetRef ref) async {
    final user = ref.read(userProvider);
    if (user == null) {
      return;
    }
    final doc = db.collection('user_taking_course').doc(user.uid);
    await doc.update({
      '2025': FieldValue.arrayRemove([lessonId]),
      'last_updated': FieldValue.serverTimestamp(),
    });
    // .onError((error, stackTrace) async {
    //   await savePersonalTimetableListToFirestore(ref);
    // });
  }

  Future<void> savePersonalTimetableListToFirestore(List<int> personalTimetableList, WidgetRef ref) async {
    final user = ref.read(userProvider);
    if (user == null) {
      return;
    }
    final doc = db.collection('user_taking_course').doc(user.uid);
    await doc.set({'2025': personalTimetableList, 'last_updated': FieldValue.serverTimestamp()});
  }

  Future<void> savePersonalTimetableList(List<int> personalTimetableList, WidgetRef ref) async {
    await ref.read(personalLessonIdListProvider.notifier).set(personalTimetableList);
  }

  Future<void> addPersonalTimetableList(int lessonId, WidgetRef ref) async {
    await ref.read(personalLessonIdListProvider.notifier).add(lessonId);
    await addPersonalTimetableListToFirestore(lessonId, ref);
  }

  Future<void> removePersonalTimetableList(int lessonId, WidgetRef ref) async {
    await ref.read(personalLessonIdListProvider.notifier).remove(lessonId);
    await removePersonalTimetableListFromFirestore(lessonId, ref);
  }

  Future<Map<String, int>> loadPersonalTimetableMapString() async {
    final personalTimetableList = await _getPersonalTimetableList();
    final dbPath = await SyllabusDatabaseConfig().getDBPath();
    final database = await openDatabase(dbPath);
    final loadPersonalTimetableMap = <String, int>{};
    final List<Map<String, dynamic>> records = await database.rawQuery(
      'select LessonId, 授業名 from sort where LessonId in '
      '(${personalTimetableList.join(",")})',
    );
    for (final record in records) {
      final lessonName = record['授業名'] as String;
      final lessonId = record['LessonId'] as int;
      loadPersonalTimetableMap[lessonName] = lessonId;
    }
    return loadPersonalTimetableMap;
  }

  // 施設予約のjsonファイルの中から取得している科目のみに絞り込み
  Future<List<dynamic>> filterTimetable() async {
    const fileName = 'map/oneweek_schedule.json';
    try {
      final jsonString = await readJsonFile(fileName);
      final jsonData = json.decode(jsonString) as List<dynamic>;
      final personalTimetableList = await _getPersonalTimetableList();
      final filteredData = <dynamic>[];
      for (final lessonId in personalTimetableList) {
        for (final item in jsonData) {
          final itemMap = item as Map<String, dynamic>;
          if (itemMap['lessonId'] == lessonId.toString()) {
            filteredData.add(item);
          }
        }
      }
      return filteredData;
    } on Exception {
      return [];
    }
  }

  Future<Map<DateTime, Map<int, List<TimetableCourse>>>> get2WeekLessonSchedule() async {
    final dates = getDateRange();
    final twoWeekLessonSchedule = <DateTime, Map<int, List<TimetableCourse>>>{};
    try {
      for (final date in dates) {
        twoWeekLessonSchedule[date] = await dailyLessonSchedule(date);
      }
      return twoWeekLessonSchedule;
    } on Exception {
      return twoWeekLessonSchedule;
    }
  }

  // 時間を入れたらその日の授業を返す
  Future<Map<int, List<TimetableCourse>>> dailyLessonSchedule(DateTime selectTime) async {
    final periodData = <int, Map<int, TimetableCourse>>{1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}};
    final returnData = <int, List<TimetableCourse>>{};

    final lessonData = await filterTimetable();

    for (final item in lessonData) {
      final itemMap = item as Map<String, dynamic>;
      final lessonTime = DateTime.parse(itemMap['start'] as String);

      if (selectTime.day == lessonTime.day) {
        final period = itemMap['period'] as int;
        final lessonId = int.parse(itemMap['lessonId'] as String);
        final resourceId = <int>[];
        try {
          resourceId.add(int.parse(itemMap['resourceId'] as String));
        } on FormatException {
          // resourceIdが空白
        }
        if (periodData.containsKey(period)) {
          if (periodData[period]!.containsKey(lessonId)) {
            periodData[period]![lessonId]!.resourseIds.addAll(resourceId);
            continue;
          }
        }
        periodData[period]![lessonId] = TimetableCourse(lessonId, itemMap['title'] as String, resourceId);
      }
    }

    var jsonData = await readJsonFile('home/cancel_lecture.json');
    final cancelLectureData = jsonDecode(jsonData) as List<dynamic>;
    jsonData = await readJsonFile('home/sup_lecture.json');
    final supLectureData = jsonDecode(jsonData) as List<dynamic>;
    final loadPersonalTimetableMap = await loadPersonalTimetableMapString();

    for (final cancelLecture in cancelLectureData) {
      final cancelMap = cancelLecture as Map<String, dynamic>;
      final dt = DateTime.parse(cancelMap['date'] as String);
      if (dt.month == selectTime.month && dt.day == selectTime.day) {
        final lessonName = cancelMap['lessonName'] as String;
        if (loadPersonalTimetableMap.containsKey(lessonName)) {
          final lessonId = loadPersonalTimetableMap[lessonName]!;
          periodData[cancelMap['period'] as int]![lessonId] = TimetableCourse(lessonId, lessonName, [], cancel: true);
        }
      }
    }

    for (final supLecture in supLectureData) {
      final supMap = supLecture as Map<String, dynamic>;
      final dt = DateTime.parse(supMap['date'] as String);
      if (dt.month == selectTime.month && dt.day == selectTime.day) {
        final lessonName = supMap['lessonName'] as String;
        if (loadPersonalTimetableMap.containsKey(lessonName)) {
          final lessonId = loadPersonalTimetableMap[lessonName]!;
          periodData[supMap['period'] as int]![lessonId] = periodData[supMap['period'] as int]![lessonId]!.withSup();
        }
      }
    }
    periodData.forEach((key, value) {
      returnData[key] = value.values.toList();
    });
    return returnData;
  }

  Future<List<Map<String, dynamic>>> fetchRecords() async {
    final dbPath = await SyllabusDatabaseConfig().getDBPath();
    final database = await openDatabase(dbPath);

    final List<Map<String, dynamic>> records = await database.rawQuery('SELECT * FROM week_period order by lessonId');
    return records;
  }

  Future<bool> isOverSeleted(int lessonId, WidgetRef ref) async {
    final personalLessonIdList = await _getPersonalTimetableList();
    final weekPeriodAllRecords = ref.watch(weekPeriodAllRecordsProvider).value;
    if (weekPeriodAllRecords != null) {
      final filterWeekPeriod = weekPeriodAllRecords.where((element) => element['lessonId'] == lessonId).toList();
      final targetWeekPeriod = filterWeekPeriod.where((element) => element['開講時期'] != 0).toList();
      for (final element in filterWeekPeriod.where((element) => element['開講時期'] == 0)) {
        final e1 = <String, dynamic>{...element};
        final e2 = <String, dynamic>{...element};
        e1['開講時期'] = 10;
        e2['開講時期'] = 20;
        targetWeekPeriod.addAll([e1, e2]);
      }
      final removeLessonIdList = <int>{};
      var flag = false;
      for (final record in targetWeekPeriod) {
        final term = record['開講時期'] as int;
        final week = record['week'] as int;
        final period = record['period'] as int;
        final selectedLessonList = weekPeriodAllRecords.where((record) {
          return record['week'] == week &&
              record['period'] == period &&
              (record['開講時期'] == term || record['開講時期'] == 0) &&
              personalLessonIdList.contains(record['lessonId']);
        }).toList();
        if (selectedLessonList.length > 1) {
          final removeLessonList = selectedLessonList.sublist(2, selectedLessonList.length);
          if (removeLessonList.isNotEmpty) {
            removeLessonIdList.addAll(removeLessonList.map((e) => e['lessonId'] as int).toSet());
          }
          flag = true;
        }
      }
      if (removeLessonIdList.isNotEmpty) {
        personalLessonIdList.removeWhere(removeLessonIdList.contains);
        await savePersonalTimetableList(personalLessonIdList, ref);
      }
      return flag;
    }
    return true;
  }
}
