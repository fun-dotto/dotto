import 'package:dotto/theme/colors/semantic_colors.dart';
import 'package:flutter/material.dart';

/// Extension for accessing semantic colors through the theme
@immutable
class DottoSemanticColors extends ThemeExtension<DottoSemanticColors> {
  const DottoSemanticColors({
    // Text Colors
    required this.textPrimary,
    required this.textSecondary,
    required this.textPlaceholder,
    required this.textDisabled,
    required this.textLink,
    required this.textOnColor,
    required this.accentPrimary,

    // Background Colors
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundDisabled,
    required this.backgroundModal,

    // State Colors
    required this.stateActive,
    required this.stateDisabled,
    required this.stateHover,

    // Border Colors
    required this.borderDivider,
    required this.borderOutline,
    required this.borderOutlineOnColor,

    // Primary Colors
    required this.primaryMain,
    required this.primaryLight,
    required this.primaryDark,

    // Expressive Colors - Success
    required this.successMain,
    required this.successLight,
    required this.successDark,

    // Expressive Colors - Info
    required this.infoMain,
    required this.infoLight,
    required this.infoDark,

    // Expressive Colors - Warning
    required this.warningMain,
    required this.warningLight,
    required this.warningDark,

    // Expressive Colors - Error
    required this.errorMain,
    required this.errorLight,
    required this.errorDark,
  });

  // Light theme semantic colors
  static const light = DottoSemanticColors(
    // Text Colors
    textPrimary: SemanticColors.textPrimary,
    textSecondary: SemanticColors.textSecondary,
    textPlaceholder: SemanticColors.textPlaceholder,
    textDisabled: SemanticColors.textDisabled,
    textLink: SemanticColors.textLink,
    textOnColor: SemanticColors.textOnColor,
    accentPrimary: SemanticColors.accentPrimary,

    // Background Colors
    backgroundPrimary: SemanticColors.backgroundPrimary,
    backgroundSecondary: SemanticColors.backgroundSecondary,
    backgroundDisabled: SemanticColors.backgroundDisabled,
    backgroundModal: SemanticColors.backgroundModal,

    // State Colors
    stateActive: SemanticColors.stateActive,
    stateDisabled: SemanticColors.stateDisabled,
    stateHover: SemanticColors.stateHover,

    // Border Colors
    borderDivider: SemanticColors.borderDivider,
    borderOutline: SemanticColors.borderOutline,
    borderOutlineOnColor: SemanticColors.borderOutlineOnColor,

    // Primary Colors
    primaryMain: SemanticColors.primaryMain,
    primaryLight: SemanticColors.primaryLight,
    primaryDark: SemanticColors.primaryDark,

    // Expressive Colors - Success
    successMain: SemanticColors.successMain,
    successLight: SemanticColors.successLight,
    successDark: SemanticColors.successDark,

    // Expressive Colors - Info
    infoMain: SemanticColors.infoMain,
    infoLight: SemanticColors.infoLight,
    infoDark: SemanticColors.infoDark,

    // Expressive Colors - Warning
    warningMain: SemanticColors.warningMain,
    warningLight: SemanticColors.warningLight,
    warningDark: SemanticColors.warningDark,

    // Expressive Colors - Error
    errorMain: SemanticColors.errorMain,
    errorLight: SemanticColors.errorLight,
    errorDark: SemanticColors.errorDark,
  );

  // Text Colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textPlaceholder;
  final Color textDisabled;
  final Color textLink;
  final Color textOnColor;
  final Color accentPrimary;

  // Background Colors
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color backgroundDisabled;
  final Color backgroundModal;

  // State Colors
  final Color stateActive;
  final Color stateDisabled;
  final Color stateHover;

  // Border Colors
  final Color borderDivider;
  final Color borderOutline;
  final Color borderOutlineOnColor;

  // Primary Colors
  final Color primaryMain;
  final Color primaryLight;
  final Color primaryDark;

  // Expressive Colors - Success
  final Color successMain;
  final Color successLight;
  final Color successDark;

  // Expressive Colors - Info
  final Color infoMain;
  final Color infoLight;
  final Color infoDark;

  // Expressive Colors - Warning
  final Color warningMain;
  final Color warningLight;
  final Color warningDark;

  // Expressive Colors - Error
  final Color errorMain;
  final Color errorLight;
  final Color errorDark;

  @override
  DottoSemanticColors copyWith({
    // Text Colors
    Color? textPrimary,
    Color? textSecondary,
    Color? textPlaceholder,
    Color? textDisabled,
    Color? textLink,
    Color? textOnColor,
    Color? accentPrimary,

    // Background Colors
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? backgroundDisabled,
    Color? backgroundModal,

    // State Colors
    Color? stateActive,
    Color? stateDisabled,
    Color? stateHover,

    // Border Colors
    Color? borderDivider,
    Color? borderOutline,
    Color? borderOutlineOnColor,

    // Primary Colors
    Color? primaryMain,
    Color? primaryLight,
    Color? primaryDark,

    // Expressive Colors - Success
    Color? successMain,
    Color? successLight,
    Color? successDark,

    // Expressive Colors - Info
    Color? infoMain,
    Color? infoLight,
    Color? infoDark,

    // Expressive Colors - Warning
    Color? warningMain,
    Color? warningLight,
    Color? warningDark,

    // Expressive Colors - Error
    Color? errorMain,
    Color? errorLight,
    Color? errorDark,
  }) {
    return DottoSemanticColors(
      // Text Colors
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textPlaceholder: textPlaceholder ?? this.textPlaceholder,
      textDisabled: textDisabled ?? this.textDisabled,
      textLink: textLink ?? this.textLink,
      textOnColor: textOnColor ?? this.textOnColor,
      accentPrimary: accentPrimary ?? this.accentPrimary,

      // Background Colors
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      backgroundDisabled: backgroundDisabled ?? this.backgroundDisabled,
      backgroundModal: backgroundModal ?? this.backgroundModal,

      // State Colors
      stateActive: stateActive ?? this.stateActive,
      stateDisabled: stateDisabled ?? this.stateDisabled,
      stateHover: stateHover ?? this.stateHover,

      // Border Colors
      borderDivider: borderDivider ?? this.borderDivider,
      borderOutline: borderOutline ?? this.borderOutline,
      borderOutlineOnColor: borderOutlineOnColor ?? this.borderOutlineOnColor,

      // Primary Colors
      primaryMain: primaryMain ?? this.primaryMain,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,

      // Expressive Colors - Success
      successMain: successMain ?? this.successMain,
      successLight: successLight ?? this.successLight,
      successDark: successDark ?? this.successDark,

      // Expressive Colors - Info
      infoMain: infoMain ?? this.infoMain,
      infoLight: infoLight ?? this.infoLight,
      infoDark: infoDark ?? this.infoDark,

      // Expressive Colors - Warning
      warningMain: warningMain ?? this.warningMain,
      warningLight: warningLight ?? this.warningLight,
      warningDark: warningDark ?? this.warningDark,

      // Expressive Colors - Error
      errorMain: errorMain ?? this.errorMain,
      errorLight: errorLight ?? this.errorLight,
      errorDark: errorDark ?? this.errorDark,
    );
  }

  @override
  ThemeExtension<DottoSemanticColors> lerp(
    covariant ThemeExtension<DottoSemanticColors>? other,
    double t,
  ) {
    if (other is! DottoSemanticColors) {
      return this;
    }

    return DottoSemanticColors(
      // Text Colors
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textPlaceholder: Color.lerp(textPlaceholder, other.textPlaceholder, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textLink: Color.lerp(textLink, other.textLink, t)!,
      textOnColor: Color.lerp(textOnColor, other.textOnColor, t)!,
      accentPrimary: Color.lerp(accentPrimary, other.accentPrimary, t)!,

      // Background Colors
      backgroundPrimary: Color.lerp(backgroundPrimary, other.backgroundPrimary, t)!,
      backgroundSecondary: Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      backgroundDisabled: Color.lerp(backgroundDisabled, other.backgroundDisabled, t)!,
      backgroundModal: Color.lerp(backgroundModal, other.backgroundModal, t)!,

      // State Colors
      stateActive: Color.lerp(stateActive, other.stateActive, t)!,
      stateDisabled: Color.lerp(stateDisabled, other.stateDisabled, t)!,
      stateHover: Color.lerp(stateHover, other.stateHover, t)!,

      // Border Colors
      borderDivider: Color.lerp(borderDivider, other.borderDivider, t)!,
      borderOutline: Color.lerp(borderOutline, other.borderOutline, t)!,
      borderOutlineOnColor: Color.lerp(borderOutlineOnColor, other.borderOutlineOnColor, t)!,

      // Primary Colors
      primaryMain: Color.lerp(primaryMain, other.primaryMain, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,

      // Expressive Colors - Success
      successMain: Color.lerp(successMain, other.successMain, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      successDark: Color.lerp(successDark, other.successDark, t)!,

      // Expressive Colors - Info
      infoMain: Color.lerp(infoMain, other.infoMain, t)!,
      infoLight: Color.lerp(infoLight, other.infoLight, t)!,
      infoDark: Color.lerp(infoDark, other.infoDark, t)!,

      // Expressive Colors - Warning
      warningMain: Color.lerp(warningMain, other.warningMain, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      warningDark: Color.lerp(warningDark, other.warningDark, t)!,

      // Expressive Colors - Error
      errorMain: Color.lerp(errorMain, other.errorMain, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      errorDark: Color.lerp(errorDark, other.errorDark, t)!,
    );
  }
}

/// Extension for more easily accessing semantic colors from the theme
extension DottoColorExtension on ThemeData {
  DottoSemanticColors get semanticColors => extension<DottoSemanticColors>()!;
}
