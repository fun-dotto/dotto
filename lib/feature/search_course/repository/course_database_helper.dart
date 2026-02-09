import 'package:dotto/feature/search_course/repository/syllabus_database_config.dart';
import 'package:sqflite/sqflite.dart';

final class CourseDatabaseHelper {
  static const String _coursesQuery = '''
    SELECT * FROM sort detail 
    INNER JOIN sort ON sort.LessonId=detail.LessonId 
    WHERE 
  ''';

  static const String _weekPeriodQuery = '''
    SELECT * FROM week_period 
    WHERE lessonId IN 
  ''';

  static Future<Database> _getDatabase() async {
    try {
      final dbPath = await SyllabusDatabaseConfig().getDBPath();
      return await openDatabase(dbPath);
    } catch (e) {
      throw DatabaseException('データベースの接続に失敗しました: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> searchCourses({
    required String whereClause,
    required String searchWord,
  }) async {
    try {
      final database = await _getDatabase();
      final records = await database.rawQuery('$_coursesQuery$whereClause');

      return records.where((record) => record['授業名']?.toString().contains(searchWord) ?? false).toList();
    } catch (e) {
      throw DatabaseException('科目検索に失敗しました: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchWeekPeriod(List<int> lessonIdList) async {
    if (lessonIdList.isEmpty) {
      return [];
    }

    try {
      final database = await _getDatabase();
      final placeholders = lessonIdList.join(',');

      return await database.rawQuery('$_weekPeriodQuery($placeholders)');
    } catch (e) {
      throw DatabaseException('時間割情報の取得に失敗しました: $e');
    }
  }
}

final class DatabaseException implements Exception {
  const DatabaseException(this.message);

  final String message;

  @override
  String toString() => 'DatabaseException: $message';
}
