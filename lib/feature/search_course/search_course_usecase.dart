import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/grade.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/helper/user_preference_repository.dart';

final class SearchCourseUsecase {
  factory SearchCourseUsecase() {
    return _instance;
  }
  SearchCourseUsecase._internal();
  static final SearchCourseUsecase _instance = SearchCourseUsecase._internal();

  Future<Grade?> getUserGrade() async {
    final deprecatedGradeKey = await UserPreferenceRepository.getString(
      UserPreferenceKeys.grade,
    );
    return Grade.fromDeprecatedUserPreferenceKey(deprecatedGradeKey ?? '');
  }

  Future<AcademicArea?> getUserAcademicArea() async {
    final deprecatedAcademicAreaKey = await UserPreferenceRepository.getString(
      UserPreferenceKeys.course,
    );
    return AcademicArea.fromDeprecatedUserPreferenceKey(
      deprecatedAcademicAreaKey ?? '',
    );
  }
}
