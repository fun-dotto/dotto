import 'package:dotto/feature/search_course/repository/syllabus_database_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
part 'week_period_all_records_controller.g.dart';

@riverpod
final class WeekPeriodAllRecordsNotifier extends _$WeekPeriodAllRecordsNotifier {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final dbPath = await SyllabusDatabaseConfig().getDBPath();
    final database = await openDatabase(dbPath);
    final List<Map<String, dynamic>> records = await database.rawQuery('SELECT * FROM week_period order by lessonId');
    return records;
  }
}
