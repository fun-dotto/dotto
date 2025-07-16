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
    required int senmonKyoyoStatus,
    required String searchWord,
  }) async {
    final database = await openDatabase(SyllabusDBConfig.dbPath);
    final sqlWhereList = <String>[];
    final sqlWhereListKyoyo = <String>[];
    var sqlWhere = '';

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

    // 専門・教養・大学院の分岐
    switch (senmonKyoyoStatus) {
      case 0:
        // 専門
        // 学年
        // ['1年', '2年', '3年', '4年']
        if (_isNotAllTrueOrAllFalse(gradeCheckList)) {
          final sqlWhereGrade = <String>[];
          final gradeIds = SearchCourseFilterOptions.grade.ids;
          for (var i = 0; i < gradeCheckList.length; i++) {
            if (gradeCheckList[i]) {
              sqlWhereGrade.add('sort.${gradeIds[i]}=1');
            }
          }
          sqlWhereList.add("(${sqlWhereGrade.join(" OR ")})");
          final classificationIds = SearchCourseFilterOptions.classification.ids;
          if (gradeCheckList[0]) {
            // 1年
            // ['必修', '選択']
            if (_isNotAllTrueOrAllFalse(classificationCheckList)) {
              for (var j = 0; j < classificationCheckList.length; j++) {
                if (classificationCheckList[j]) {
                  sqlWhereList.add('(sort.一年コース=${classificationIds[j]})');
                }
              }
            }
          } else {
            // コース・専門
            // ['情シス', 'デザイン', '複雑', '知能', '高度ICT']
            // ['必修', '選択']
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
                    // 必修選択関係なし
                    sqlWhereCourseClassification.add('sort.${courseIds[i]}!=0');
                  }
                }
              }
            } else {
              sqlWhereCourseClassification.add('sort.専門=1');
            }
            if (sqlWhereCourseClassification.isNotEmpty) {
              sqlWhereList.add("(${sqlWhereCourseClassification.join(" OR ")})");
            }
          }
        }
        break;
      case 1:
        // 教養
        final sqlWhereKyoyo = <String>[];
        sqlWhereListKyoyo.add('(sort.教養!=0)');
        if (_isNotAllTrueOrAllFalse(educationCheckList)) {
          final educationIds = SearchCourseFilterOptions.educationField.ids;
          for (var i = 0; i < educationCheckList.length; i++) {
            if (educationCheckList[i]) {
              sqlWhereKyoyo.add('sort.教養=${educationIds[i]}');
            }
          }
          sqlWhereListKyoyo.add("(${sqlWhereKyoyo.join(" OR ")})");
        }
        if (_isNotAllTrueOrAllFalse(classificationCheckList)) {
          if (classificationCheckList[0]) {
            sqlWhereListKyoyo.add('(sort.教養必修=1)');
          }
          if (classificationCheckList[1]) {
            sqlWhereListKyoyo.add('(sort.教養必修!=1)');
          }
        }
        sqlWhereList.add("(${sqlWhereListKyoyo.join(" AND ")})");
        break;
      case 2:
        // 大学院
        sqlWhereList.add("(sort.LessonId LIKE '5_____')");
        var masterFieldInt = 0;
        for (var i = 0; i < masterFieldCheckList.length; i++) {
          if (masterFieldCheckList[i]) {
            masterFieldInt |= 1 << masterFieldCheckList.length - i - 1;
          }
        }
        if (masterFieldInt == 0) {
          masterFieldInt = 63;
        }
        sqlWhereList.add('(sort.大学院 & $masterFieldInt)');
        break;
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
        .where(
            (record) => record['授業名'].toString().contains(searchWord))
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
