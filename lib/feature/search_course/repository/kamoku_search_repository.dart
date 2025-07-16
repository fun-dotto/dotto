import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:dotto/importer.dart';
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
      'SELECT * FROM week_period '
      'where lessonId in (${lessonIdList.join(',')})',
    );
    return records;
  }

  Future<List<Map<String, dynamic>>> searchCourses({
    required Map<SearchCourseFilterOptions, List<bool>> filterSelections,
    required String searchWord,
  }) async {
    final database = await openDatabase(SyllabusDBConfig.dbPath);
    final sqlWhereList = <String>[];
    var sqlWhere = '';

    final largeCategoryCheckList =
        filterSelections[SearchCourseFilterOptions.largeCategory] ?? [];
    final termCheckList =
        filterSelections[SearchCourseFilterOptions.term] ?? [];
    final gradeCheckList =
        filterSelections[SearchCourseFilterOptions.grade] ?? [];
    final courseCheckList =
        filterSelections[SearchCourseFilterOptions.course] ?? [];
    final classificationCheckList =
        filterSelections[SearchCourseFilterOptions.classification] ?? [];
    final educationCheckList =
        filterSelections[SearchCourseFilterOptions.educationField] ?? [];
    final masterFieldCheckList =
        filterSelections[SearchCourseFilterOptions.masterField] ?? [];

    // 開講時期
    // ['前期', '後期', '通年']
    final sqlWhereTerm = <String>[];
    if (_isNotAllTrueOrAllFalse(termCheckList)) {
      final termIds = SearchCourseFilterOptions.term.ids;
      for (var i = 0; i < termCheckList.length; i++) {
        if (termCheckList[i]) {
          sqlWhereTerm.add(termIds[i]);
        }
      }
      sqlWhereList.add("(sort.開講時期 IN (${sqlWhereTerm.join(", ")}))");
    }

    // 専門・教養・大学院の分岐（複数選択可能）
    final categoryConditions = <String>[];
    
    // 専門が選択されている場合
    if (largeCategoryCheckList.isNotEmpty && largeCategoryCheckList[0]) {
      final senmonConditions = <String>[];
      
      // 学年
      if (_isNotAllTrueOrAllFalse(gradeCheckList)) {
        final sqlWhereGrade = <String>[];
        final gradeIds = SearchCourseFilterOptions.grade.ids;
        for (var i = 0; i < gradeCheckList.length; i++) {
          if (gradeCheckList[i]) {
            sqlWhereGrade.add('sort.${gradeIds[i]}=1');
          }
        }
        senmonConditions.add("(${sqlWhereGrade.join(" OR ")})");
        
        final classificationIds = SearchCourseFilterOptions.classification.ids;
        if (gradeCheckList[0]) {
          // 1年
          if (_isNotAllTrueOrAllFalse(classificationCheckList)) {
            for (var j = 0; j < classificationCheckList.length; j++) {
              if (classificationCheckList[j]) {
                senmonConditions.add('(sort.一年コース=${classificationIds[j]})');
              }
            }
          }
        } else {
          // コース・専門
          final sqlWhereCourseClassification = <String>[];
          final courseIds = SearchCourseFilterOptions.course.ids;

          if (_isNotAllTrueOrAllFalse(courseCheckList)) {
            for (var i = 0; i < courseCheckList.length; i++) {
              if (courseCheckList[i]) {
                if (_isNotAllTrueOrAllFalse(classificationCheckList)) {
                  for (var j = 0; j < classificationCheckList.length; j++) {
                    if (classificationCheckList[j]) {
                      sqlWhereCourseClassification.add(
                          'sort.${courseIds[i]}=${classificationIds[j]}');
                    }
                  }
                } else {
                  sqlWhereCourseClassification.add('sort.${courseIds[i]}!=0');
                }
              }
            }
          } else {
            sqlWhereCourseClassification.add('sort.専門=1');
          }
          if (sqlWhereCourseClassification.isNotEmpty) {
            senmonConditions.add("(${sqlWhereCourseClassification.join(" OR ")})");
          }
        }
      } else {
        senmonConditions.add('sort.専門=1');
      }
      
      if (senmonConditions.isNotEmpty) {
        categoryConditions.add("(${senmonConditions.join(" AND ")})");
      }
    }
    
    // 教養が選択されている場合
    if (largeCategoryCheckList.length > 1 && largeCategoryCheckList[1]) {
      final kyoyoConditions = <String>[];
      kyoyoConditions.add('(sort.教養!=0)');
      
      if (_isNotAllTrueOrAllFalse(educationCheckList)) {
        final educationIds = SearchCourseFilterOptions.educationField.ids;
        final sqlWhereKyoyo = <String>[];
        for (var i = 0; i < educationCheckList.length; i++) {
          if (educationCheckList[i]) {
            sqlWhereKyoyo.add('sort.教養=${educationIds[i]}');
          }
        }
        kyoyoConditions.add("(${sqlWhereKyoyo.join(" OR ")})");
      }
      
      if (_isNotAllTrueOrAllFalse(classificationCheckList)) {
        final classificationConditions = <String>[];
        if (classificationCheckList[0]) {
          classificationConditions.add('(sort.教養必修=1)');
        }
        if (classificationCheckList[1]) {
          classificationConditions.add('(sort.教養必修!=1)');
        }
        kyoyoConditions.addAll(classificationConditions);
      }
      
      if (kyoyoConditions.isNotEmpty) {
        categoryConditions.add("(${kyoyoConditions.join(" AND ")})");
      }
    }
    
    // 大学院が選択されている場合
    if (largeCategoryCheckList.length > 2 && largeCategoryCheckList[2]) {
      final graduateConditions = <String>[];
      graduateConditions.add("(sort.LessonId LIKE '5_____')");
      
      var masterFieldInt = 0;
      for (var i = 0; i < masterFieldCheckList.length; i++) {
        if (masterFieldCheckList[i]) {
          masterFieldInt |= 1 << masterFieldCheckList.length - i - 1;
        }
      }
      if (masterFieldInt == 0) {
        masterFieldInt = 63;
      }
      graduateConditions.add('(sort.大学院 & $masterFieldInt)');
      
      if (graduateConditions.isNotEmpty) {
        categoryConditions.add("(${graduateConditions.join(" AND ")})");
      }
    }
    
    // カテゴリ条件をORで結合
    if (categoryConditions.isNotEmpty) {
      sqlWhereList.add("(${categoryConditions.join(" OR ")})");
    }

    if (sqlWhereList.isNotEmpty) {
      sqlWhere = sqlWhereList.join(' AND ');
    }

    debugPrint(sqlWhere);
    List<Map<String, dynamic>> records;
    sqlWhere = (sqlWhere == '') ? '1' : sqlWhere;
    records =
        await database.rawQuery('SELECT * FROM sort detail INNER JOIN sort ON '
            'sort.LessonId=detail.LessonId WHERE $sqlWhere');
    return records
        .where((record) => record['授業名'].toString().contains(searchWord))
        .toList();
  }

  bool _isNotAllTrueOrAllFalse(List<bool> list) {
    if (list.every((element) => element)) {
      return false;
    } else if (list.every((element) => !element)) {
      return false;
    } else {
      return true;
    }
  }
}
