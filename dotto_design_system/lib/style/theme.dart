import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class DottoTheme {
  static ThemeData get v2 {
    return ThemeData(
      colorScheme: const ColorScheme.light(),
      fontFamily: 'NotoSansJP',
      extensions: [SemanticColor.light],
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        displayMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        displaySmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        headlineLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        headlineMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        headlineSmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        titleLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        titleMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        titleSmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        bodyLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        bodySmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        labelLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        labelMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        labelSmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      ),
    );
  }
}
