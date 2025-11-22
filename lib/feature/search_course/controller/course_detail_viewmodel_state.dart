import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_detail_viewmodel_state.freezed.dart';

@freezed
abstract class CourseDetailViewModelState with _$CourseDetailViewModelState {
  const factory CourseDetailViewModelState({
    required Map<SearchCourseFilterOptions, List<bool>> filterSelections,
    required List<Map<String, dynamic>>? searchResults,
    required TextEditingController textEditingController,
    required FocusNode searchBoxFocusNode,
    @Default({
      SearchCourseFilterOptions.largeCategory,
      SearchCourseFilterOptions.term,
    })
    Set<SearchCourseFilterOptions> visibilityStatus,
    @Default('') String searchWord,
  }) = _CourseDetailViewModelState;
}
