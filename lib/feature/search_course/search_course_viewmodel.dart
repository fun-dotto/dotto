import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/search_course/search_course_viewmodel_state.dart';
import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:dotto/feature/search_course/repository/search_course_repository.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_course_viewmodel.g.dart';

@riverpod
final class SearchCourseViewModel extends _$SearchCourseViewModel {
  @override
  Future<SearchCourseViewModelState> build() async {
    await updateCheckListFromPreferences();
    return SearchCourseViewModelState(
      filterSelections: Map.fromIterables(
        SearchCourseFilterOptions.values,
        SearchCourseFilterOptions.values.map(
          (e) => List.filled(e.choices.length, false),
        ),
      ),
      searchResults: null,
      textEditingController: TextEditingController(),
      focusNode: FocusNode(),
    );
  }

  Future<void> updateCheckListFromPreferences() async {
    final savedGrade = await UserPreferenceRepository.getString(
      UserPreferenceKeys.grade,
    );
    final savedCourse = await UserPreferenceRepository.getString(
      UserPreferenceKeys.course,
    );
    final filterSelections = state.value?.filterSelections ?? {};
    if (savedGrade != null) {
      final index = SearchCourseFilterOptions.grade.labels.indexOf(savedGrade);
      if (index != -1 &&
          index < filterSelections[SearchCourseFilterOptions.grade]!.length) {
        filterSelections[SearchCourseFilterOptions.grade]![index] = true;
      }
    }
    if (savedCourse != null) {
      final index = SearchCourseFilterOptions.course.labels.indexOf(
        savedCourse,
      );
      if (index != -1 &&
          index < filterSelections[SearchCourseFilterOptions.course]!.length) {
        filterSelections[SearchCourseFilterOptions.course]![index] = true;
      }
    }
    state = AsyncValue.data(
      state.value?.copyWith(filterSelections: filterSelections) ??
          SearchCourseViewModelState(
            filterSelections: filterSelections,
            searchResults: null,
            textEditingController: TextEditingController(),
            focusNode: FocusNode(),
          ),
    );
  }

  void reset() {
    final filterSelections =
        Map<SearchCourseFilterOptions, List<bool>>.fromIterables(
          SearchCourseFilterOptions.values,
          SearchCourseFilterOptions.values.map(
            (e) => List.filled(e.choices.length, false),
          ),
        );
    final visibilityStatus = <SearchCourseFilterOptions>{
      SearchCourseFilterOptions.largeCategory,
      SearchCourseFilterOptions.term,
    };
    state.value?.textEditingController.clear();
    state = AsyncValue.data(
      state.value?.copyWith(
            filterSelections: filterSelections,
            visibilityStatus: visibilityStatus,
          ) ??
          SearchCourseViewModelState(
            filterSelections: filterSelections,
            searchResults: null,
            textEditingController: TextEditingController(),
            focusNode: FocusNode(),
            visibilityStatus: visibilityStatus,
          ),
    );
  }

  void checkboxOnChanged({
    required bool? value,
    required SearchCourseFilterOptions filterOption,
    required int index,
  }) {
    final filterSelections = state.value?.filterSelections ?? {};
    filterSelections[filterOption]![index] = value ?? false;
    if (filterOption == SearchCourseFilterOptions.grade &&
        index > 0 &&
        filterSelections[SearchCourseFilterOptions.grade]![0]) {
      filterSelections[SearchCourseFilterOptions.grade]![0] = false;
    }
    if (filterSelections[SearchCourseFilterOptions.grade]!.any(
      (element) => element,
    )) {
      if (filterSelections[SearchCourseFilterOptions.grade]![0]) {
        for (
          var i = 1;
          i < filterSelections[SearchCourseFilterOptions.grade]!.length;
          i++
        ) {
          filterSelections[SearchCourseFilterOptions.grade]![i] = false;
        }
      }
    }
    state = AsyncValue.data(
      state.value?.copyWith(
            filterSelections: filterSelections,
            visibilityStatus: setVisibilityStatus(filterSelections),
          ) ??
          SearchCourseViewModelState(
            filterSelections: filterSelections,
            searchResults: null,
            textEditingController: TextEditingController(),
            focusNode: FocusNode(),
            visibilityStatus: setVisibilityStatus(filterSelections),
          ),
    );
  }

  Set<SearchCourseFilterOptions> setVisibilityStatus(
    Map<SearchCourseFilterOptions, List<bool>> filterSelections,
  ) {
    final largeCategorySelections =
        filterSelections[SearchCourseFilterOptions.largeCategory] ?? [];
    final visibilityStatus = <SearchCourseFilterOptions>{
      SearchCourseFilterOptions.largeCategory,
      SearchCourseFilterOptions.term,
    };

    // 専門が選択されている場合
    if (largeCategorySelections[0]) {
      visibilityStatus.add(SearchCourseFilterOptions.grade);
      if (filterSelections[SearchCourseFilterOptions.grade]!.any(
            (element) => element,
          ) ||
          filterSelections[SearchCourseFilterOptions.course]!.any(
            (element) => element,
          )) {
        visibilityStatus.add(SearchCourseFilterOptions.classification);
        if (!filterSelections[SearchCourseFilterOptions.grade]![0]) {
          visibilityStatus.add(SearchCourseFilterOptions.course);
        }
      }
    }

    // 教養が選択されている場合
    if (largeCategorySelections[1]) {
      visibilityStatus
        ..add(SearchCourseFilterOptions.educationField)
        ..add(SearchCourseFilterOptions.classification);
    }

    // 大学院が選択されている場合
    if (largeCategorySelections[2]) {
      visibilityStatus.add(SearchCourseFilterOptions.masterField);
    }

    return visibilityStatus;
  }

  // 科目検索ボタンが押されたときの処理
  Future<void> search() async {
    final repository = SearchCourseRepository();
    final searchResults = await repository.searchCourses(
      filterSelections: state.value?.filterSelections ?? {},
      searchWord: state.value?.textEditingController.text ?? '',
    );
    state = AsyncValue.data(
      state.value?.copyWith(searchResults: searchResults) ??
          SearchCourseViewModelState(
            filterSelections: state.value?.filterSelections ?? {},
            searchResults: searchResults,
            textEditingController: TextEditingController(),
            focusNode: FocusNode(),
            visibilityStatus: state.value?.visibilityStatus ?? {},
          ),
    );
  }

  void onCleared() {
    state.value?.textEditingController.clear();
  }
}
