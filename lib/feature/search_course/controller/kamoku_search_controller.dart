import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:dotto/feature/search_course/repository/search_course_repository.dart';
import 'package:dotto/feature/setting/domain/grade.dart';
import 'package:dotto/repository/user_preference_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'kamoku_search_controller.freezed.dart';

final kamokuSearchControllerProvider =
    StateNotifierProvider<
      KamokuSearchControllerProvider,
      KamokuSearchController
    >((ref) => KamokuSearchControllerProvider());

@freezed
abstract class KamokuSearchController with _$KamokuSearchController {
  const factory KamokuSearchController({
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
  }) = _KamokuSearchController;
}

final class KamokuSearchControllerProvider
    extends StateNotifier<KamokuSearchController> {
  KamokuSearchControllerProvider()
    : super(
        KamokuSearchController(
          filterSelections: Map.fromIterables(
            SearchCourseFilterOptions.values,
            SearchCourseFilterOptions.values.map(
              (e) => List.filled(e.choices.length, false),
            ),
          ),
          searchResults: null,
          textEditingController: TextEditingController(),
          searchBoxFocusNode: FocusNode(),
        ),
      ) {
    Future(() async {
      await updateCheckListFromPreferences();
    });
  }

  Future<void> updateCheckListFromPreferences() async {
    final savedGrade = await UserPreferenceRepository.getString(
      UserPreferenceKeys.grade,
    );
    final savedCourse = await UserPreferenceRepository.getString(
      UserPreferenceKeys.course,
    );
    final filterSelections = state.filterSelections;
    if (savedGrade != null && savedGrade != 'なし') {
      final grade = Grade.values.asNameMap()[savedGrade];
      if (grade != null) {
        final index = SearchCourseFilterOptions.grade.labels.indexOf(
          grade.label,
        );
        if (index != -1 &&
            index < filterSelections[SearchCourseFilterOptions.grade]!.length) {
          filterSelections[SearchCourseFilterOptions.grade]![index] = true;
        }
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
    state = state.copyWith(filterSelections: filterSelections);
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
    const searchWord = '';
    state.textEditingController.clear();
    state = state.copyWith(
      filterSelections: filterSelections,
      visibilityStatus: visibilityStatus,
      searchWord: searchWord,
    );
  }

  void setSearchWord(String word) {
    state = state.copyWith(searchWord: word);
  }

  void checkboxOnChanged({
    required bool? value,
    required SearchCourseFilterOptions filterOption,
    required int index,
  }) {
    final filterSelections = state.filterSelections;
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
    state = state.copyWith(
      filterSelections: filterSelections,
      visibilityStatus: setVisibilityStatus(filterSelections),
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
      filterSelections: state.filterSelections,
      searchWord: state.searchWord,
    );
    state = state.copyWith(searchResults: searchResults);
  }
}
