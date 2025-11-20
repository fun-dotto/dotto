import 'package:dotto/theme/v1/color_fun.dart';
import 'package:flutter/material.dart';

final class DottoThemev1 {
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: customFunColor,
      colorScheme: const ColorScheme.light(primary: customFunColor),
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: customFunColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade300),
      fontFamily: 'NotoSansJP',
    );
  }
}
