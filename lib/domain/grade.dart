import 'package:collection/collection.dart';

enum Grade {
  b1(
    label: '学部1年',
    deprecatedUserPreferenceKey: '1年',
    deprecatedFilterOptionChoiceKey: '一年次',
  ),
  b2(
    label: '学部2年',
    deprecatedUserPreferenceKey: '2年',
    deprecatedFilterOptionChoiceKey: '二年次',
  ),
  b3(
    label: '学部3年',
    deprecatedUserPreferenceKey: '3年',
    deprecatedFilterOptionChoiceKey: '三年次',
  ),
  b4(
    label: '学部4年',
    deprecatedUserPreferenceKey: '4年',
    deprecatedFilterOptionChoiceKey: '四年次',
  ),
  m1(label: '修士1年'),
  m2(label: '修士2年'),
  d1(label: '博士1年'),
  d2(label: '博士2年'),
  d3(label: '博士3年');

  const Grade({
    required this.label,
    this.deprecatedUserPreferenceKey,
    this.deprecatedFilterOptionChoiceKey,
  });

  final String label;
  final String? deprecatedUserPreferenceKey;
  final String? deprecatedFilterOptionChoiceKey;

  static Grade? fromDeprecatedUserPreferenceKey(String key) {
    return values.firstWhereOrNull((e) => e.deprecatedUserPreferenceKey == key);
  }
}
