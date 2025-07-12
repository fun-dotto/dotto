import 'package:dotto/repository/db_config.dart';
import 'package:sqflite/sqflite.dart';

final class KamokuSearchRepository {
  factory KamokuSearchRepository() {
    return _instance;
  }
  KamokuSearchRepository._internal();
  static final KamokuSearchRepository _instance =
      KamokuSearchRepository._internal();

  Future<List<Map<String, dynamic>>> fetchWeekPeriodDB(
      List<int> lessonIdList) async {
    final database = await openDatabase(SyllabusDBConfig.dbPath);

    final List<Map<String, dynamic>> records = await database.rawQuery(
        'SELECT * FROM week_period where lessonId in (${lessonIdList.join(',')})');
    return records;
  }
}
