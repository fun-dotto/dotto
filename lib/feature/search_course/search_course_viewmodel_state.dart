import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/grade.dart';
import 'package:dotto/feature/search_course/domain/search_course_filter_option_choice.dart';
import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_course_viewmodel_state.freezed.dart';

@freezed
abstract class SearchCourseViewModelState with _$SearchCourseViewModelState {
  const factory SearchCourseViewModelState({
    required Map<SearchCourseFilterOptions, List<SearchCourseFilterOptionChoice>> selectedChoicesMap,
    required Set<SearchCourseFilterOptions> visibilityStatus,
    required List<Map<String, dynamic>>? searchResults,
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    required Grade? grade,
    required AcademicArea? academicArea,
  }) = _SearchCourseViewModelState;
}
