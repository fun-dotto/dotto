import 'package:collection/collection.dart';

enum AcademicArea {
  informationSystemCourse(
    label: '情報システムコース',
    deprecatedUserPreferenceKey: '情報システム',
    deprecatedFilterOptionChoiceKey: '情報システムコース',
  ),
  informationDesignCourse(
    label: '情報デザインコース',
    deprecatedUserPreferenceKey: '情報デザイン',
    deprecatedFilterOptionChoiceKey: '情報デザインコース',
  ),
  complexCourse(label: '複雑系コース', deprecatedUserPreferenceKey: '複雑', deprecatedFilterOptionChoiceKey: '複雑系コース'),
  intelligenceSystemCourse(
    label: '知能システムコース',
    deprecatedUserPreferenceKey: '知能',
    deprecatedFilterOptionChoiceKey: '知能システムコース',
  ),
  advancedICTCourse(
    label: '高度ICTコース',
    deprecatedUserPreferenceKey: '高度ICT',
    deprecatedFilterOptionChoiceKey: '高度ICTコース',
  ),
  informationArchitectureArea(label: '情報アーキテクチャ領域'),
  mediaDesignArea(label: 'メディアデザイン領域'),
  complexInformationScienceArea(label: '複雑系情報科学領域'),
  intelligenceInformationScienceArea(label: '知能情報科学領域'),
  advancedICTArea(label: '高度ICT領域');

  const AcademicArea({required this.label, this.deprecatedUserPreferenceKey, this.deprecatedFilterOptionChoiceKey});

  final String label;
  final String? deprecatedUserPreferenceKey;
  final String? deprecatedFilterOptionChoiceKey;

  static AcademicArea? fromDeprecatedUserPreferenceKey(String key) {
    return values.firstWhereOrNull((e) => e.deprecatedUserPreferenceKey == key);
  }
}
