import 'package:dotto/feature/search_course/domain/search_course_filter_options.dart';
import 'package:dotto/feature/search_course/repository/kamoku_search_repository.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/repository/setting_user_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'kamoku_search_controller.freezed.dart';

final kamokuSearchControllerProvider = StateNotifierProvider<
    KamokuSearchControllerProvider,
    KamokuSearchController>((ref) => KamokuSearchControllerProvider());

@freezed
abstract class KamokuSearchController with _$KamokuSearchController {
  const factory KamokuSearchController({
    required int senmonKyoyoStatus,
    required Map<SearchCourseFilterOptions, List<bool>> filterSelections,
    required List<Map<String, dynamic>>? searchResults,
    required TextEditingController textEditingController,
    required FocusNode searchBoxFocusNode,
    @Default({SearchCourseFilterOptions.term})
    Set<SearchCourseFilterOptions> visibilityStatus,
    @Default('') String searchWord,
  }) = _KamokuSearchController;
}

final class KamokuSearchControllerProvider
    extends StateNotifier<KamokuSearchController> {
  KamokuSearchControllerProvider()
      : super(KamokuSearchController(
          senmonKyoyoStatus: -1,
          filterSelections: Map.fromIterables(
              SearchCourseFilterOptions.values,
              SearchCourseFilterOptions.values
                  .map((e) => List.filled(e.choices.length, false))),
          searchResults: null,
          textEditingController: TextEditingController(),
          searchBoxFocusNode: FocusNode(),
        )) {
    Future(
      () async {
        await updateCheckListFromPreferences();
      },
    );
  }

  Future<void> updateCheckListFromPreferences() async {
    final savedGrade =
        await UserPreferences.getString(UserPreferenceKeys.grade);
    final savedCourse =
        await UserPreferences.getString(UserPreferenceKeys.course);
    final filterSelections = state.filterSelections;
    if (savedGrade != null) {
      final index = SearchCourseFilterOptions.grade.labels.indexOf(savedGrade);
      if (index != -1 &&
          index < filterSelections[SearchCourseFilterOptions.grade]!.length) {
        filterSelections[SearchCourseFilterOptions.grade]![index] = true;
      }
    }
    if (savedCourse != null) {
      final index = SearchCourseFilterOptions.course.labels.indexOf(savedCourse);
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
            SearchCourseFilterOptions.values
                .map((e) => List.filled(e.choices.length, false)));
    final visibilityStatus = <SearchCourseFilterOptions>{SearchCourseFilterOptions.term};
    const searchWord = '';
    state.textEditingController.clear();
    state = state.copyWith(
      senmonKyoyoStatus: -1,
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
    if (filterSelections[SearchCourseFilterOptions.grade]!
        .any((element) => element)) {
      if (filterSelections[SearchCourseFilterOptions.grade]![0]) {
        for (var i = 1;
            i < filterSelections[SearchCourseFilterOptions.grade]!.length;
            i++) {
          filterSelections[SearchCourseFilterOptions.grade]![i] = false;
        }
      }
    }
    state = state.copyWith(
      filterSelections: filterSelections,
      visibilityStatus:
          setVisibilityStatus(filterSelections, state.senmonKyoyoStatus),
    );
  }

  // Radioボタンが押されたときの処理
  void radioOnChanged(int? value) {
    final senmonKyoyoStatus = value ?? -1;
    state = state.copyWith(
      senmonKyoyoStatus: senmonKyoyoStatus,
      visibilityStatus:
          setVisibilityStatus(state.filterSelections, senmonKyoyoStatus),
    );
  }

  // Radioボタンが押されたときの処理 2
  Set<SearchCourseFilterOptions> setVisibilityStatus(
      Map<SearchCourseFilterOptions, List<bool>> filterSelections,
      int senmonKyoyoStatus) {
    var visibilityStatus = state.visibilityStatus;
    if (senmonKyoyoStatus == 0) {
      // 専門
      visibilityStatus = {
        SearchCourseFilterOptions.term,
        SearchCourseFilterOptions.grade,
      };
      if (filterSelections[SearchCourseFilterOptions.grade]!
              .any((element) => element) ||
          filterSelections[SearchCourseFilterOptions.course]!
              .any((element) => element)) {
        visibilityStatus.add(SearchCourseFilterOptions.classification);
        if (!filterSelections[SearchCourseFilterOptions.grade]![0]) {
          visibilityStatus.add(SearchCourseFilterOptions.course);
        }
      } else {
        visibilityStatus.remove(SearchCourseFilterOptions.classification);
      }
    } else if (senmonKyoyoStatus == 1) {
      // 教養
      visibilityStatus = {
        SearchCourseFilterOptions.term,
        SearchCourseFilterOptions.educationField,
        SearchCourseFilterOptions.classification
      };
    } else if (senmonKyoyoStatus == 2) {
      // 大学院
      visibilityStatus = {
        SearchCourseFilterOptions.term,
        SearchCourseFilterOptions.masterField,
      };
    }
    return visibilityStatus;
  }


  // 科目検索ボタンが押されたときの処理
  Future<void> search() async {
    final repository = KamokuSearchRepository();
    final searchResults = await repository.searchCourses(
      filterSelections: state.filterSelections,
      senmonKyoyoStatus: state.senmonKyoyoStatus,
      searchWord: state.searchWord,
    );
    state = state.copyWith(searchResults: searchResults);
  }
}
