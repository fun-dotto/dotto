import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';

final class CourseSearchQueryBuilder {
  static const String _graduateLessonIdPattern = '5_____';
  static const int _allMasterFieldsMask = 63;

  final List<String> _whereConditions = [];

  void addTermFilter(List<bool> termCheckList) {
    if (!_isNotAllTrueOrAllFalse(termCheckList)) return;

    final termIds = SearchCourseFilterOptions.term.ids;
    final selectedTermIds = <String>[];

    for (var i = 0; i < termCheckList.length; i++) {
      if (termCheckList[i]) {
        selectedTermIds.add(termIds[i]);
      }
    }

    if (selectedTermIds.isNotEmpty) {
      _whereConditions.add("(sort.開講時期 IN (${selectedTermIds.join(", ")}))");
    }
  }

  void addCategoryFilters({
    required List<bool> largeCategoryCheckList,
    required List<bool> gradeCheckList,
    required List<bool> courseCheckList,
    required List<bool> classificationCheckList,
    required List<bool> educationCheckList,
    required List<bool> masterFieldCheckList,
  }) {
    final categoryConditions = <String>[];

    // 専門
    if (largeCategoryCheckList.isNotEmpty && largeCategoryCheckList[0]) {
      final senmonCondition = _buildSenmonConditions(
        gradeCheckList,
        courseCheckList,
        classificationCheckList,
      );
      if (senmonCondition.isNotEmpty) {
        categoryConditions.add(senmonCondition);
      }
    }

    // 教養
    if (largeCategoryCheckList.length > 1 && largeCategoryCheckList[1]) {
      final kyoyoCondition = _buildKyoyoConditions(
        educationCheckList,
        classificationCheckList,
      );
      if (kyoyoCondition.isNotEmpty) {
        categoryConditions.add(kyoyoCondition);
      }
    }

    // 大学院
    if (largeCategoryCheckList.length > 2 && largeCategoryCheckList[2]) {
      final graduateCondition = _buildGraduateConditions(masterFieldCheckList);
      if (graduateCondition.isNotEmpty) {
        categoryConditions.add(graduateCondition);
      }
    }

    if (categoryConditions.isNotEmpty) {
      _whereConditions.add("(${categoryConditions.join(" OR ")})");
    }
  }

  String build() {
    if (_whereConditions.isEmpty) {
      return '1';
    }
    return _whereConditions.join(' AND ');
  }

  String _buildSenmonConditions(
    List<bool> gradeCheckList,
    List<bool> courseCheckList,
    List<bool> classificationCheckList,
  ) {
    final senmonConditions = <String>[];

    if (_isNotAllTrueOrAllFalse(gradeCheckList)) {
      final gradeConditions = _buildGradeConditions(gradeCheckList);
      if (gradeConditions.isNotEmpty) {
        senmonConditions.add(gradeConditions);
      }

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
        final courseClassificationCondition =
            _buildCourseClassificationConditions(
          courseCheckList,
          classificationCheckList,
        );
        if (courseClassificationCondition.isNotEmpty) {
          senmonConditions.add(courseClassificationCondition);
        }
      }
    } else {
      senmonConditions.add('sort.専門=1');
    }

    return senmonConditions.isEmpty
        ? ''
        : "(${senmonConditions.join(" AND ")})";
  }

  String _buildGradeConditions(List<bool> gradeCheckList) {
    final gradeIds = SearchCourseFilterOptions.grade.ids;
    final sqlWhereGrade = <String>[];

    for (var i = 0; i < gradeCheckList.length; i++) {
      if (gradeCheckList[i]) {
        sqlWhereGrade.add('sort.${gradeIds[i]}=1');
      }
    }

    return sqlWhereGrade.isEmpty ? '' : "(${sqlWhereGrade.join(" OR ")})";
  }

  String _buildCourseClassificationConditions(
    List<bool> courseCheckList,
    List<bool> classificationCheckList,
  ) {
    final sqlWhereCourseClassification = <String>[];
    final courseIds = SearchCourseFilterOptions.course.ids;
    final classificationIds = SearchCourseFilterOptions.classification.ids;

    if (_isNotAllTrueOrAllFalse(courseCheckList)) {
      for (var i = 0; i < courseCheckList.length; i++) {
        if (courseCheckList[i]) {
          if (_isNotAllTrueOrAllFalse(classificationCheckList)) {
            for (var j = 0; j < classificationCheckList.length; j++) {
              if (classificationCheckList[j]) {
                sqlWhereCourseClassification
                    .add('sort.${courseIds[i]}=${classificationIds[j]}');
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

    return sqlWhereCourseClassification.isEmpty
        ? ''
        : "(${sqlWhereCourseClassification.join(" OR ")})";
  }

  String _buildKyoyoConditions(
    List<bool> educationCheckList,
    List<bool> classificationCheckList,
  ) {
    final kyoyoConditions = <String>['(sort.教養!=0)'];

    if (_isNotAllTrueOrAllFalse(educationCheckList)) {
      final educationIds = SearchCourseFilterOptions.educationField.ids;
      final sqlWhereKyoyo = <String>[];
      for (var i = 0; i < educationCheckList.length; i++) {
        if (educationCheckList[i]) {
          sqlWhereKyoyo.add('sort.教養=${educationIds[i]}');
        }
      }
      if (sqlWhereKyoyo.isNotEmpty) {
        kyoyoConditions.add("(${sqlWhereKyoyo.join(" OR ")})");
      }
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

    return kyoyoConditions.isEmpty ? '' : "(${kyoyoConditions.join(" AND ")})";
  }

  String _buildGraduateConditions(List<bool> masterFieldCheckList) {
    final graduateConditions = <String>[
      "(sort.LessonId LIKE '$_graduateLessonIdPattern')"
    ];

    var masterFieldInt = 0;
    for (var i = 0; i < masterFieldCheckList.length; i++) {
      if (masterFieldCheckList[i]) {
        masterFieldInt |= 1 << masterFieldCheckList.length - i - 1;
      }
    }
    if (masterFieldInt == 0) {
      masterFieldInt = _allMasterFieldsMask;
    }
    graduateConditions.add('(sort.大学院 & $masterFieldInt)');

    return graduateConditions.isEmpty
        ? ''
        : "(${graduateConditions.join(" AND ")})";
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
