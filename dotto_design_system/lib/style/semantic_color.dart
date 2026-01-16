import 'package:dotto_design_system/style/primitive_color.dart';
import 'package:flutter/material.dart';

@immutable
final class SemanticColor extends ThemeExtension<SemanticColor> {
  const SemanticColor({
    required this.labelPrimary,
    required this.labelSecondary,
    required this.labelTertiary,

    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundTertiary,
    required this.backgroundQuaternary,

    required this.borderPrimary,
    required this.borderSecondary,

    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentSuccess,
    required this.accentInfo,
    required this.accentWarning,
    required this.accentError,
  });

  // Label
  final Color labelPrimary;
  final Color labelSecondary;
  final Color labelTertiary;

  // Background
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color backgroundTertiary;
  final Color backgroundQuaternary;

  // Border
  final Color borderPrimary;
  final Color borderSecondary;

  // Accent
  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentSuccess;
  final Color accentInfo;
  final Color accentWarning;
  final Color accentError;

  static final light = SemanticColor(
    labelPrimary: PrimitiveColor.gray900,
    labelSecondary: PrimitiveColor.gray600,
    labelTertiary: PrimitiveColor.white,

    backgroundPrimary: PrimitiveColor.gray50,
    backgroundSecondary: PrimitiveColor.white,
    backgroundTertiary: PrimitiveColor.gray200,
    backgroundQuaternary: PrimitiveColor.gray900.withValues(alpha: 0.4),

    borderPrimary: PrimitiveColor.gray200,
    borderSecondary: PrimitiveColor.white,

    accentPrimary: PrimitiveColor.accent,
    accentSecondary: PrimitiveColor.red300,
    accentSuccess: PrimitiveColor.green600,
    accentInfo: PrimitiveColor.blue600,
    accentWarning: PrimitiveColor.orange600,
    accentError: PrimitiveColor.red600,
  );

  @override
  ThemeExtension<SemanticColor> copyWith({
    Color? labelPrimary,
    Color? labelSecondary,
    Color? labelTertiary,
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? backgroundTertiary,
    Color? backgroundQuaternary,
    Color? borderPrimary,
    Color? borderSecondary,
    Color? accentPrimary,
    Color? accentSecondary,
    Color? accentSuccess,
    Color? accentInfo,
    Color? accentWarning,
    Color? accentError,
  }) {
    return SemanticColor(
      labelPrimary: labelPrimary ?? this.labelPrimary,
      labelSecondary: labelSecondary ?? this.labelSecondary,
      labelTertiary: labelTertiary ?? this.labelTertiary,
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      backgroundTertiary: backgroundTertiary ?? this.backgroundTertiary,
      backgroundQuaternary: backgroundQuaternary ?? this.backgroundQuaternary,
      borderPrimary: borderPrimary ?? this.borderPrimary,
      borderSecondary: borderSecondary ?? this.borderSecondary,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      accentSuccess: accentSuccess ?? this.accentSuccess,
      accentInfo: accentInfo ?? this.accentInfo,
      accentWarning: accentWarning ?? this.accentWarning,
      accentError: accentError ?? this.accentError,
    );
  }

  @override
  ThemeExtension<SemanticColor> lerp(
    covariant ThemeExtension<SemanticColor>? other,
    double t,
  ) {
    if (other is! SemanticColor) {
      return this;
    }
    return SemanticColor(
      labelPrimary: Color.lerp(labelPrimary, other.labelPrimary, t)!,
      labelSecondary: Color.lerp(labelSecondary, other.labelSecondary, t)!,
      labelTertiary: Color.lerp(labelTertiary, other.labelTertiary, t)!,
      backgroundPrimary: Color.lerp(
        backgroundPrimary,
        other.backgroundPrimary,
        t,
      )!,
      backgroundSecondary: Color.lerp(
        backgroundSecondary,
        other.backgroundSecondary,
        t,
      )!,
      backgroundTertiary: Color.lerp(
        backgroundTertiary,
        other.backgroundTertiary,
        t,
      )!,
      backgroundQuaternary: Color.lerp(
        backgroundQuaternary,
        other.backgroundQuaternary,
        t,
      )!,
      borderPrimary: Color.lerp(borderPrimary, other.borderPrimary, t)!,
      borderSecondary: Color.lerp(borderSecondary, other.borderSecondary, t)!,
      accentPrimary: Color.lerp(accentPrimary, other.accentPrimary, t)!,
      accentSecondary: Color.lerp(accentSecondary, other.accentSecondary, t)!,
      accentSuccess: Color.lerp(accentSuccess, other.accentSuccess, t)!,
      accentInfo: Color.lerp(accentInfo, other.accentInfo, t)!,
      accentWarning: Color.lerp(accentWarning, other.accentWarning, t)!,
      accentError: Color.lerp(accentError, other.accentError, t)!,
    );
  }
}
