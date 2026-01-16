import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class DottoTheme {
  static ThemeData get v2 {
    return ThemeData(
      primarySwatch: MaterialColor(
        SemanticColor.light.accentPrimary.toARGB32(),
        <int, Color>{
          50: SemanticColor.light.accentPrimary.withValues(alpha: 0.05),
          100: SemanticColor.light.accentPrimary.withValues(alpha: 0.1),
          200: SemanticColor.light.accentPrimary.withValues(alpha: 0.2),
          300: SemanticColor.light.accentPrimary.withValues(alpha: 0.3),
          400: SemanticColor.light.accentPrimary.withValues(alpha: 0.4),
          500: SemanticColor.light.accentPrimary.withValues(alpha: 0.5),
          600: SemanticColor.light.accentPrimary.withValues(alpha: 0.6),
          700: SemanticColor.light.accentPrimary.withValues(alpha: 0.7),
          800: SemanticColor.light.accentPrimary.withValues(alpha: 0.8),
          900: SemanticColor.light.accentPrimary.withValues(alpha: 0.9),
        },
      ),
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
      fontFamily: 'NotoSansJP',
      extensions: [SemanticColor.light],
      // textTheme: const TextTheme(
      //   displayLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   displayMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   displaySmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   headlineLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   headlineMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   headlineSmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   titleLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   titleMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   titleSmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   bodyLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   bodySmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   labelLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   labelMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      //   labelSmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      // ),
    );
  }
}
