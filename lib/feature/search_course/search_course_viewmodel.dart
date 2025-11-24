import 'package:collection/collection.dart';
import 'package:dotto/feature/search_course/domain/search_course_filter_option_choice.dart';
import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:dotto/feature/search_course/repository/search_course_repository.dart';
import 'package:dotto/feature/search_course/search_course_usecase.dart';
import 'package:dotto/feature/search_course/search_course_viewmodel_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_course_viewmodel.g.dart';

@riverpod
final class SearchCourseViewModel extends _$SearchCourseViewModel {
  @override
  Future<SearchCourseViewModelState> build() async {
    final grade = await SearchCourseUsecase().getUserGrade();
    final academicArea = await SearchCourseUsecase().getUserAcademicArea();
    return SearchCourseViewModelState(
      selectedChoicesMap: Map.fromIterables(
        SearchCourseFilterOptions.values,
        SearchCourseFilterOptions.values.map((e) => []),
      ),
      visibilityStatus: {
        SearchCourseFilterOptions.largeCategory,
        SearchCourseFilterOptions.term,
        SearchCourseFilterOptions.classification,
      },
      searchResults: null,
      textEditingController: TextEditingController(),
      focusNode: FocusNode(),
      grade: grade,
      academicArea: academicArea,
    );
  }

  Future<void> onSearchButtonTapped() async {
    switch (state) {
      case AsyncData(:final value):
        value.focusNode.unfocus();
        final repository = SearchCourseRepository();
        final searchResults = await repository.searchCourses(
          selectedChoicesMap: value.selectedChoicesMap,
          searchWord: value.textEditingController.text,
        );
        final newState = value.copyWith(searchResults: searchResults);
        state = AsyncValue.data(newState);
      case AsyncLoading():
        return;
      case AsyncError():
        return;
    }
  }

  void onCleared() {
    switch (state) {
      case AsyncData(:final value):
        value.textEditingController.clear();
      case AsyncLoading():
        return;
      case AsyncError():
        return;
    }
  }

  void onCheckboxTapped({
    required SearchCourseFilterOptions filterOption,
    required SearchCourseFilterOptionChoice choice,
    required bool? isSelected,
  }) {
    debugPrint(
      'onCheckboxTapped: ${filterOption.name}, ${choice.label}, $isSelected',
    );
    switch (state) {
      case AsyncData(:final value):
        // Create a mutable deep copy of the map and its lists
        final selectedChoicesMap =
            Map<
              SearchCourseFilterOptions,
              List<SearchCourseFilterOptionChoice>
            >.fromEntries(
              value.selectedChoicesMap.entries.map(
                (entry) => MapEntry(
                  entry.key,
                  List<SearchCourseFilterOptionChoice>.from(entry.value),
                ),
              ),
            );
        if (isSelected ?? false) {
          selectedChoicesMap[filterOption]?.add(choice);
        } else {
          selectedChoicesMap[filterOption]?.remove(choice);
        }

        final visibilityStatus = _setVisibilityStatus(selectedChoicesMap);

        for (final e in SearchCourseFilterOptions.values) {
          if (value.visibilityStatus.contains(e) &&
              !visibilityStatus.contains(e)) {
            selectedChoicesMap[e] = [];
          }
        }

        if (!value.visibilityStatus.contains(SearchCourseFilterOptions.grade) &&
            visibilityStatus.contains(SearchCourseFilterOptions.grade)) {
          final gradeChoice = SearchCourseFilterOptions.grade.choices
              .firstWhereOrNull(
                (e) => e.id == value.grade?.deprecatedFilterOptionChoiceKey,
              );
          if (gradeChoice != null) {
            selectedChoicesMap[SearchCourseFilterOptions.grade]?.add(
              gradeChoice,
            );
          }
        }

        if (!value.visibilityStatus.contains(
              SearchCourseFilterOptions.course,
            ) &&
            visibilityStatus.contains(SearchCourseFilterOptions.course)) {
          final courseChoice = SearchCourseFilterOptions.course.choices
              .firstWhereOrNull(
                (e) =>
                    e.id == value.academicArea?.deprecatedFilterOptionChoiceKey,
              );
          if (courseChoice != null) {
            selectedChoicesMap[SearchCourseFilterOptions.course]?.add(
              courseChoice,
            );
          }
        }

        final newState = value.copyWith(
          selectedChoicesMap: selectedChoicesMap,
          visibilityStatus: visibilityStatus,
        );
        state = AsyncValue.data(newState);
      case AsyncLoading():
        return;
      case AsyncError():
        return;
    }
  }

  Set<SearchCourseFilterOptions> _setVisibilityStatus(
    Map<SearchCourseFilterOptions, List<SearchCourseFilterOptionChoice>>
    selectedChoicesMap,
  ) {
    final visibilityStatus = <SearchCourseFilterOptions>{
      SearchCourseFilterOptions.largeCategory,
      SearchCourseFilterOptions.term,
      SearchCourseFilterOptions.classification,
    };

    // 専門が選択されている場合
    if (selectedChoicesMap[SearchCourseFilterOptions.largeCategory]?.contains(
          SearchCourseFilterOptions.largeCategory.choices[0],
        ) ??
        false) {
      visibilityStatus
        ..add(SearchCourseFilterOptions.grade)
        ..add(SearchCourseFilterOptions.course);
    }

    // 教養が選択されている場合
    if (selectedChoicesMap[SearchCourseFilterOptions.largeCategory]?.contains(
          SearchCourseFilterOptions.largeCategory.choices[1],
        ) ??
        false) {
      visibilityStatus
        ..add(SearchCourseFilterOptions.grade)
        ..add(SearchCourseFilterOptions.educationField);
    }

    // 大学院が選択されている場合
    if (selectedChoicesMap[SearchCourseFilterOptions.largeCategory]?.contains(
          SearchCourseFilterOptions.largeCategory.choices[2],
        ) ??
        false) {
      visibilityStatus.add(SearchCourseFilterOptions.masterField);
    }

    return visibilityStatus;
  }

  void onResultRowTapped(Map<String, dynamic> record) {
    state.value?.focusNode.unfocus();
  }
}
