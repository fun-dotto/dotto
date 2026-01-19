import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class DottoTheme {
  static ThemeData get v2 {
    return ThemeData(
      colorScheme: const ColorScheme.light(),
      fontFamily: 'NotoSansJP',
      extensions: const [SemanticColor.light],
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
