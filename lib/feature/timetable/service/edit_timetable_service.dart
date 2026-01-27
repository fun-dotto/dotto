import 'dart:convert';

import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/search_course/repository/syllabus_database_config.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final class EditTimetableService {
  EditTimetableService(this.ref);

  final Ref ref;

  Future<List<Map<String, dynamic>>> getWeekPeriodAllRecords() async {
    final dbPath = await SyllabusDatabaseConfig().getDBPath();
    final database = await openDatabase(dbPath);
    final List<Map<String, dynamic>> records = await database.rawQuery(
      'SELECT * FROM week_period order by lessonId',
    );
    return records;
  }

  Future<List<int>> getPersonalLessonIdList() async {
    final jsonString = await UserPreferenceRepository.getString(
      UserPreferenceKeys.personalTimetableListKey,
    );
    if (jsonString != null) {
      return List<int>.from(json.decode(jsonString) as List);
    }
    return [];
  }
}
