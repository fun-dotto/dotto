import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:dotto_design_system/style/text_style.dart';
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
        titleTextStyle: DottoTextStyle.titleMedium.copyWith(
          color: SemanticColor.light.accentPrimary,
        ),
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade300),
      fontFamily: 'NotoSansJP',
      extensions: [SemanticColor.light],
      textTheme: const TextTheme(
        displayLarge: DottoTextStyle.displayLarge,
        displayMedium: DottoTextStyle.displayMedium,
        displaySmall: DottoTextStyle.displaySmall,
        headlineLarge: DottoTextStyle.headlineLarge,
        headlineMedium: DottoTextStyle.headlineMedium,
        headlineSmall: DottoTextStyle.headlineSmall,
        titleLarge: DottoTextStyle.titleLarge,
        titleMedium: DottoTextStyle.titleMedium,
        titleSmall: DottoTextStyle.titleSmall,
        bodyLarge: DottoTextStyle.bodyLarge,
        bodyMedium: DottoTextStyle.bodyMedium,
        bodySmall: DottoTextStyle.bodySmall,
        labelLarge: DottoTextStyle.labelLarge,
        labelMedium: DottoTextStyle.labelMedium,
        labelSmall: DottoTextStyle.labelSmall,
      ),
    );
  }
}
