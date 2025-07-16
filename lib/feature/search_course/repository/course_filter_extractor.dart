import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';

final class CourseFilterExtractor {
  static CourseFilterData extractFilters(
    Map<SearchCourseFilterOptions, List<bool>> filterSelections,
  ) {
    return CourseFilterData(
      largeCategoryCheckList: 
          filterSelections[SearchCourseFilterOptions.largeCategory] ?? [],
      termCheckList: 
          filterSelections[SearchCourseFilterOptions.term] ?? [],
      gradeCheckList: 
          filterSelections[SearchCourseFilterOptions.grade] ?? [],
      courseCheckList: 
          filterSelections[SearchCourseFilterOptions.course] ?? [],
      classificationCheckList: 
          filterSelections[SearchCourseFilterOptions.classification] ?? [],
      educationCheckList: 
          filterSelections[SearchCourseFilterOptions.educationField] ?? [],
      masterFieldCheckList: 
          filterSelections[SearchCourseFilterOptions.masterField] ?? [],
    );
  }
}

final class CourseFilterData {
  const CourseFilterData({
    required this.largeCategoryCheckList,
    required this.termCheckList,
    required this.gradeCheckList,
    required this.courseCheckList,
    required this.classificationCheckList,
    required this.educationCheckList,
    required this.masterFieldCheckList,
  });

  final List<bool> largeCategoryCheckList;
  final List<bool> termCheckList;
  final List<bool> gradeCheckList;
  final List<bool> courseCheckList;
  final List<bool> classificationCheckList;
  final List<bool> educationCheckList;
  final List<bool> masterFieldCheckList;
}
