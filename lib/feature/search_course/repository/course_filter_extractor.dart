import 'package:dotto/feature/search_course/domain/search_course_filter_option_choice.dart';
import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';

final class CourseFilterExtractor {
  static CourseFilterData extractFilters(
    Map<SearchCourseFilterOptions, List<SearchCourseFilterOptionChoice>>
    selectedChoicesMap,
  ) {
    return CourseFilterData(
      largeCategoryCheckList: SearchCourseFilterOptions.largeCategory.choices
          .map(
            (choice) =>
                selectedChoicesMap[SearchCourseFilterOptions.largeCategory]
                    ?.contains(choice) ??
                false,
          )
          .toList(),
      termCheckList: SearchCourseFilterOptions.term.choices
          .map(
            (choice) =>
                selectedChoicesMap[SearchCourseFilterOptions.term]?.contains(
                  choice,
                ) ??
                false,
          )
          .toList(),
      classificationCheckList: SearchCourseFilterOptions.classification.choices
          .map(
            (choice) =>
                selectedChoicesMap[SearchCourseFilterOptions.classification]
                    ?.contains(choice) ??
                false,
          )
          .toList(),
      gradeCheckList: SearchCourseFilterOptions.grade.choices
          .map(
            (choice) =>
                selectedChoicesMap[SearchCourseFilterOptions.grade]?.contains(
                  choice,
                ) ??
                false,
          )
          .toList(),
      courseCheckList: SearchCourseFilterOptions.course.choices
          .map(
            (choice) =>
                selectedChoicesMap[SearchCourseFilterOptions.course]?.contains(
                  choice,
                ) ??
                false,
          )
          .toList(),
      educationCheckList: SearchCourseFilterOptions.educationField.choices
          .map(
            (choice) =>
                selectedChoicesMap[SearchCourseFilterOptions.educationField]
                    ?.contains(choice) ??
                false,
          )
          .toList(),
      masterFieldCheckList: SearchCourseFilterOptions.masterField.choices
          .map(
            (choice) =>
                selectedChoicesMap[SearchCourseFilterOptions.masterField]
                    ?.contains(choice) ??
                false,
          )
          .toList(),
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
