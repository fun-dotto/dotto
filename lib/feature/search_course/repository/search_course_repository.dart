import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:dotto/feature/search_course/repository/course_database_helper.dart';
import 'package:dotto/feature/search_course/repository/course_filter_extractor.dart';
import 'package:dotto/feature/search_course/repository/course_search_query_builder.dart';
import 'package:dotto/importer.dart';

final class SearchCourseRepository {
  factory SearchCourseRepository() {
    return _instance;
  }
  SearchCourseRepository._internal();
  static final SearchCourseRepository _instance =
      SearchCourseRepository._internal();

  Future<List<Map<String, dynamic>>> fetchWeekPeriodDB(
      List<int> lessonIdList) async {
    return CourseDatabaseHelper.fetchWeekPeriod(lessonIdList);
  }

  Future<List<Map<String, dynamic>>> searchCourses({
    required Map<SearchCourseFilterOptions, List<bool>> filterSelections,
    required String searchWord,
  }) async {
    try {
      final filterData = CourseFilterExtractor.extractFilters(filterSelections);
      final queryBuilder = CourseSearchQueryBuilder()
        ..addTermFilter(filterData.termCheckList)
        ..addCategoryFilters(
          largeCategoryCheckList: filterData.largeCategoryCheckList,
          gradeCheckList: filterData.gradeCheckList,
          courseCheckList: filterData.courseCheckList,
          classificationCheckList: filterData.classificationCheckList,
          educationCheckList: filterData.educationCheckList,
          masterFieldCheckList: filterData.masterFieldCheckList,
        );

      final whereClause = queryBuilder.build();
      debugPrint(whereClause);

      return await CourseDatabaseHelper.searchCourses(
        whereClause: whereClause,
        searchWord: searchWord,
      );
    } catch (e) {
      debugPrint('科目検索エラー: $e');
      rethrow;
    }
  }
}
