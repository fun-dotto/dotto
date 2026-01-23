import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class DottoTheme {
  static ThemeData get v2 {
    return ThemeData(
      primarySwatch: SemanticColor.accentMaterialColor,
      colorScheme: ColorScheme.light(
        primary: SemanticColor.light.accentPrimary,
        surface: SemanticColor.light.backgroundPrimary,
        onSurface: SemanticColor.light.labelPrimary,
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: SemanticColor.light.accentPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade300),
      fontFamily: 'MPLUS1p',
      extensions: [SemanticColor.light],
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        displayMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
        headlineLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        titleLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        titleMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
        bodyLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        labelLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        labelMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      ),
    );
  }
}
