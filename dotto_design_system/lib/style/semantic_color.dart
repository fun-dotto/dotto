import 'package:dotto_design_system/style/primitive_color.dart';
import 'package:flutter/material.dart';

@immutable
final class SemanticColor extends ThemeExtension<SemanticColor> {
  const SemanticColor({
    required this.labelPrimary,
    required this.labelSecondary,
    required this.labelTertiary,
    required this.labelDisabled,

    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundDisabled,

    required this.borderPrimary,
    required this.borderSecondary,
    required this.borderTertiary,

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
  final Color labelDisabled;

  // Background
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color backgroundDisabled;

  // Border
  final Color borderPrimary;
  final Color borderSecondary;
  final Color borderTertiary;

  // Accent
  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentSuccess;
  final Color accentInfo;
  final Color accentWarning;
  final Color accentError;

  static const light = SemanticColor(
    labelPrimary: PrimitiveColor.gray900,
    labelSecondary: PrimitiveColor.gray600,
    labelTertiary: PrimitiveColor.gray300,
    labelDisabled: PrimitiveColor.gray500,

    backgroundPrimary: PrimitiveColor.gray100,
    backgroundSecondary: PrimitiveColor.white,
    backgroundDisabled: PrimitiveColor.gray300,

    borderPrimary: PrimitiveColor.gray400,
    borderSecondary: PrimitiveColor.gray300,
    borderTertiary: PrimitiveColor.gray500,

    accentPrimary: PrimitiveColor.accent,
    accentSecondary: PrimitiveColor.red300,
    accentSuccess: PrimitiveColor.green600,
    accentInfo: PrimitiveColor.blue600,
    accentWarning: PrimitiveColor.yellow600,
    accentError: PrimitiveColor.red600,
  );

  @override
  ThemeExtension<SemanticColor> copyWith({
    Color? labelPrimary,
    Color? labelSecondary,
    Color? labelTertiary,
    Color? labelDisabled,
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? backgroundDisabled,
    Color? borderPrimary,
    Color? borderSecondary,
    Color? borderTertiary,
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
      labelDisabled: labelDisabled ?? this.labelDisabled,
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      backgroundDisabled: backgroundDisabled ?? this.backgroundDisabled,
      borderPrimary: borderPrimary ?? this.borderPrimary,
      borderSecondary: borderSecondary ?? this.borderSecondary,
      borderTertiary: borderTertiary ?? this.borderTertiary,
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
      labelDisabled: Color.lerp(labelDisabled, other.labelDisabled, t)!,
      backgroundPrimary:
          Color.lerp(backgroundPrimary, other.backgroundPrimary, t)!,
      backgroundSecondary:
          Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      backgroundDisabled:
          Color.lerp(backgroundDisabled, other.backgroundDisabled, t)!,
      borderPrimary: Color.lerp(borderPrimary, other.borderPrimary, t)!,
      borderSecondary: Color.lerp(borderSecondary, other.borderSecondary, t)!,
      borderTertiary: Color.lerp(borderTertiary, other.borderTertiary, t)!,
      accentPrimary: Color.lerp(accentPrimary, other.accentPrimary, t)!,
      accentSecondary: Color.lerp(accentSecondary, other.accentSecondary, t)!,
      accentSuccess: Color.lerp(accentSuccess, other.accentSuccess, t)!,
      accentInfo: Color.lerp(accentInfo, other.accentInfo, t)!,
      accentWarning: Color.lerp(accentWarning, other.accentWarning, t)!,
      accentError: Color.lerp(accentError, other.accentError, t)!,
    );
  }
}
