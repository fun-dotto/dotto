import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/repository/db_config.dart';
import 'package:dotto/repository/read_json_file.dart';
import 'package:dotto/repository/setting_user_info.dart';
import 'package:sqflite/sqflite.dart';

/// 時間割データの取得・管理を行うリポジトリクラス
class TimetableRepository {
  
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
    final database = await openDatabase(SyllabusDBConfig.dbPath);

    final records = await database.rawQuery(
      'SELECT LessonId, 過去問, 授業名 FROM sort where LessonId = ?',
      [lessonId],
    );
    if (records.isEmpty) {
      return null;
    }
    return records.first;
  }

  Future<List<String>> getLessonNameList(List<int> lessonIdList) async {
    final database = await openDatabase(SyllabusDBConfig.dbPath);

    final List<Map<String, dynamic>> records = await database
        .rawQuery('SELECT 授業名 FROM sort WHERE LessonId in (${lessonIdList.join(",")})');
    final lessonNameList = records.map((e) => e['授業名'] as String).toList();
    return lessonNameList;
  }

  Future<List<int>> loadLocalPersonalTimeTableList() async {
    final jsonString = await UserPreferences.getString(UserPreferenceKeys.personalTimetableListKey);
    if (jsonString != null) {
      return List<int>.from(json.decode(jsonString));
    }
    return [];
  }

  Future<void> loadPersonalTimeTableListOnLogin(BuildContext context, WidgetRef ref) async {
    final user = ref.read(userProvider);
    if (user == null) {
      return;
    }
    var personalTimeTableList = <int>[];
    final doc = db.collection('user_taking_course').doc(user.uid);
    final docSnapshot = await doc.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        final firestoreLastUpdated = data['last_updated'] as Timestamp;
        final localLastUpdated =
            await UserPreferences.getInt(UserPreferenceKeys.personalTimetableLastUpdateKey) ?? 0;
        final diff = localLastUpdated - firestoreLastUpdated.millisecondsSinceEpoch;
        final firestoreList = List<int>.from(data['2025']);
        final localList = await loadLocalPersonalTimeTableList();
        if (localList.isEmpty) {
          personalTimeTableList = firestoreList;
        } else if (firestoreList.isEmpty) {
          personalTimeTableList = localList;
          savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
        } else if (diff.abs() > 300000) {
          final firestoreSet = firestoreList.toSet();
          final localSet = localList.toSet();
          // firestoreList と locallist のIDが同じかどうか確認
          if (firestoreSet.containsAll(localSet) && localSet.containsAll(firestoreSet)) {
            personalTimeTableList = firestoreList;
          } else {
            // LessonName取得
            final firestoreLessonNameList =
                await getLessonNameList(firestoreSet.difference(localSet).toList());
            final localLessonNameList =
                await getLessonNameList(localSet.difference(firestoreSet).toList());
            if (context.mounted) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('データの同期'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const Text('アカウントに紐づいている時間割とローカルの時間割が異なっています。どちらを残しますか？'),
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
                          personalTimeTableList = firestoreList;
                          Navigator.of(context).pop();
                        },
                        child: const Text('アカウント方を残す'),
                      ),
                      TextButton(
                        onPressed: () async {
                          personalTimeTableList = localList;
                          savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
                          Navigator.of(context).pop();
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
          personalTimeTableList = firestoreList;
        }
      } else {
        personalTimeTableList = await loadLocalPersonalTimeTableList();
        savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
      }
    } else {
      personalTimeTableList = await loadLocalPersonalTimeTableList();
      savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
    }
  }

  Future<List<int>> loadPersonalTimeTableList(WidgetRef ref) async {
    final user = ref.read(userProvider);
    var personalTimeTableList = <int>[];
    if (user == null) {
      Timer(const Duration(seconds: 1), () {});
      personalTimeTableList = await loadLocalPersonalTimeTableList();
    } else {
      final doc = db.collection('user_taking_course').doc(user.uid);
      final docSnapshot = await doc.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          final firestoreLastUpdated = data['last_updated'] as Timestamp;
          final localLastUpdated =
              await UserPreferences.getInt(UserPreferenceKeys.personalTimetableLastUpdateKey) ?? 0;
          final diff = localLastUpdated - firestoreLastUpdated.millisecondsSinceEpoch;
          final firestoreList = List<int>.from(data['2025']);
          final localList = await loadLocalPersonalTimeTableList(); // ここなぜか取得できない
          if (localList.isEmpty) {
            personalTimeTableList = firestoreList;
          } else if (firestoreList.isEmpty || diff > 600000) {
            personalTimeTableList = localList;
            savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
          } else {
            personalTimeTableList = firestoreList;
          }
        } else {
          personalTimeTableList = await loadLocalPersonalTimeTableList();
          savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
        }
      } else {
        personalTimeTableList = await loadLocalPersonalTimeTableList();
        savePersonalTimeTableListToFirestore(personalTimeTableList, ref);
      }
    }
    await savePersonalTimeTableList(personalTimeTableList, ref);
    return personalTimeTableList;
  }

  Future<void> addPersonalTimeTableListToFirestore(int lessonId, WidgetRef ref) async {
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
    //   await savePersonalTimeTableListToFirestore(ref);
    // });
  }

  Future<void> removePersonalTimeTableListFromFirestore(int lessonId, WidgetRef ref) async {
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
    //   await savePersonalTimeTableListToFirestore(ref);
    // });
  }

  Future<void> savePersonalTimeTableListToFirestore(
      List<int> personalTimeTableList, WidgetRef ref) async {
    final user = ref.read(userProvider);
    if (user == null) {
      return;
    }
    final doc = db.collection('user_taking_course').doc(user.uid);
    await doc.set({
      '2025': personalTimeTableList,
      'last_updated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> savePersonalTimeTableList(List<int> personalTimeTableList, WidgetRef ref) async {
    ref.read(personalLessonIdListProvider.notifier).set(personalTimeTableList);
  }

  Future<void> addPersonalTimeTableList(int lessonId, WidgetRef ref) async {
    ref.read(personalLessonIdListProvider.notifier).add(lessonId);
    await addPersonalTimeTableListToFirestore(lessonId, ref);
  }

  Future<void> removePersonalTimeTableList(int lessonId, WidgetRef ref) async {
    ref.read(personalLessonIdListProvider.notifier).remove(lessonId);
    await removePersonalTimeTableListFromFirestore(lessonId, ref);
  }

  Future<Map<String, int>> loadPersonalTimeTableMapString(WidgetRef ref) async {
    final var personalTimeTableListInt = ref.read(personalLessonIdListProvider);

    final var database = await openDatabase(SyllabusDBConfig.dbPath);
    final var loadPersonalTimeTableMap = <String, int>{};
    final List<Map<String, dynamic>> records = await database.rawQuery(
        'select LessonId, 授業名 from sort where LessonId in (${personalTimeTableListInt.join(",")})');
    for (final record in records) {
      final String lessonName = record['授業名'];
      final int lessonId = record['LessonId'];
      loadPersonalTimeTableMap[lessonName] = lessonId;
    }
    return loadPersonalTimeTableMap;
  }

  // 施設予約のjsonファイルの中から取得している科目のみに絞り込み
  Future<List<dynamic>> filterTimeTable(WidgetRef ref) async {
    const fileName = 'map/oneweek_schedule.json';
    try {
      final jsonString = await readJsonFile(fileName);
      final List<dynamic> jsonData = json.decode(jsonString);

      final var personalTimeTableList = ref.read(personalLessonIdListProvider);

      final filteredData = <dynamic>[];
      for (final lessonId in personalTimeTableList) {
        for (final item in jsonData) {
          if (item['lessonId'] == lessonId.toString()) {
            filteredData.add(item);
          }
        }
      }
      return filteredData;
    } catch (e) {
      return [];
    }
  }

  Future<Map<DateTime, Map<int, List<TimeTableCourse>>>> get2WeekLessonSchedule(
      WidgetRef ref) async {
    final dates = getDateRange();
    final twoWeekLessonSchedule = <DateTime, Map<int, List<TimeTableCourse>>>{};
    try {
      for (final date in dates) {
        twoWeekLessonSchedule[date] = await dailyLessonSchedule(date, ref);
      }
      return twoWeekLessonSchedule;
    } catch (e) {
      return twoWeekLessonSchedule;
    }
  }

// 時間を入れたらその日の授業を返す
  Future<Map<int, List<TimeTableCourse>>> dailyLessonSchedule(
      DateTime selectTime, WidgetRef ref) async {
    final var periodData = <int, Map<int, TimeTableCourse>>{1: {}, 2: {}, 3: {}, 4: {}, 5: {}, 6: {}};
    final returnData = <int, List<TimeTableCourse>>{};

    final lessonData = await filterTimeTable(ref);

    for (final item in lessonData) {
      final lessonTime = DateTime.parse(item['start']);

      if (selectTime.day == lessonTime.day) {
        final int period = item['period'];
        final lessonId = int.parse(item['lessonId']);
        final resourceId = <int>[];
        try {
          resourceId.add(int.parse(item['resourceId']));
        } catch (e) {
          // resourceIdが空白
        }
        if (periodData.containsKey(period)) {
          if (periodData[period]!.containsKey(lessonId)) {
            periodData[period]![lessonId]!.resourseIds.addAll(resourceId);
            continue;
          }
        }
        periodData[period]![lessonId] = TimeTableCourse(lessonId, item['title'], resourceId);
      }
    }

    var jsonData = await readJsonFile('home/cancel_lecture.json');
    final List<dynamic> cancelLectureData = jsonDecode(jsonData);
    jsonData = await readJsonFile('home/sup_lecture.json');
    final List<dynamic> supLectureData = jsonDecode(jsonData);
    final loadPersonalTimeTableMap = await loadPersonalTimeTableMapString(ref);

    for (final cancelLecture in cancelLectureData) {
      final dt = DateTime.parse(cancelLecture['date']);
      if (dt.month == selectTime.month && dt.day == selectTime.day) {
        final String lessonName = cancelLecture['lessonName'];
        if (loadPersonalTimeTableMap.containsKey(lessonName)) {
          final var lessonId = loadPersonalTimeTableMap[lessonName]!;
          periodData[cancelLecture['period']]![lessonId] =
              TimeTableCourse(lessonId, lessonName, [], cancel: true);
        }
      }
    }

    for (final supLecture in supLectureData) {
      final var dt = DateTime.parse(supLecture['date']);
      if (dt.month == selectTime.month && dt.day == selectTime.day) {
        final String lessonName = supLecture['lessonName'];
        if (loadPersonalTimeTableMap.containsKey(lessonName)) {
          final lessonId = loadPersonalTimeTableMap[lessonName]!;
          periodData[supLecture['period']]![lessonId]!.sup = true;
        }
      }
    }
    periodData.forEach((key, value) {
      returnData[key] = value.values.toList();
    });
    return returnData;
  }

  Future<List<Map<String, dynamic>>> fetchRecords() async {
    final database = await openDatabase(SyllabusDBConfig.dbPath);

    final List<Map<String, dynamic>> records =
        await database.rawQuery('SELECT * FROM week_period order by lessonId');
    return records;
  }

  Future<bool> isOverSeleted(int lessonId, WidgetRef ref) async {
    final personalLessonIdList = ref.watch(personalLessonIdListProvider);
    final weekPeriodAllRecords = ref.watch(weekPeriodAllRecordsProvider).value;
    if (weekPeriodAllRecords != null) {
      final filterWeekPeriod =
          weekPeriodAllRecords.where((element) => element['lessonId'] == lessonId).toList();
      final targetWeekPeriod =
          filterWeekPeriod.where((element) => element['開講時期'] != 0).toList();
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
        final int term = record['開講時期'];
        final int week = record['week'];
        final int period = record['period'];
        final var selectedLessonList = weekPeriodAllRecords.where((record) {
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
        await savePersonalTimeTableList(personalLessonIdList, ref);
      }
      return flag;
    }
    return true;
  }
}
