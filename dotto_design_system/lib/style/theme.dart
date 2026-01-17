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
        largeTitleEmphasis: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        headlineRegular: TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
        titleRegular: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
        titleEmphasis: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        bodyRegular: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        bodyEmphasis: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        captionRegular: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        captionEmphasis: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
