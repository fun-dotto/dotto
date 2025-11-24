import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_course_viewmodel_state.freezed.dart';

@freezed
abstract class SearchCourseViewModelState with _$SearchCourseViewModelState {
  const factory SearchCourseViewModelState({
    required Map<SearchCourseFilterOptions, List<bool>> filterSelections,
    required List<Map<String, dynamic>>? searchResults,
    required TextEditingController textEditingController,
    required FocusNode focusNode,
    @Default({
      SearchCourseFilterOptions.largeCategory,
      SearchCourseFilterOptions.term,
    })
    Set<SearchCourseFilterOptions> visibilityStatus,
    @Default('') String searchWord,
  }) = _SearchCourseViewModelState;
}
