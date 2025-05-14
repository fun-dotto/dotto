import 'package:flutter/material.dart';
import 'colors/theme_extension.dart';

class DottoTheme {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light(),
      extensions: [
        DottoSemanticColors.light,
      ],
    );
  }
}
