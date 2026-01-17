import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class DottoTheme {
  static ThemeData get v2 {
    return ThemeData(
      colorScheme: const ColorScheme.light(),
      fontFamily: 'Inter',
      extensions: const [SemanticColor.light],
      textTheme: const TextTheme(
        largeTitleRegular: TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
        largeTitleEmphasized: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        headlineRegular: TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
        titleRegular: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
        titleEmphasized: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        bodyRegular: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        bodyEmphasized: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        captionRegular: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        captionEmphasized: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
