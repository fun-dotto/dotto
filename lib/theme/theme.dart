import 'package:flutter/material.dart';
import 'colors/theme_extension.dart';
import 'package:dotto/components/color_fun.dart';

class DottoTheme {
  static ThemeData get v2 {
    return ThemeData(
      colorScheme: const ColorScheme.light(),
      fontFamily: 'NotoSansJP',
      extensions: [
        DottoSemanticColors.light,
      ],
    );
  }

  static ThemeData get v1 {
    return ThemeData(
      primarySwatch: customFunColor,
      colorScheme: ColorScheme.light(
        primary: customFunColor,
        onSurface: Colors.grey.shade900,
        surface: Colors.grey.shade100,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(0)),
          elevation: const WidgetStatePropertyAll(2),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: customFunColor,
        foregroundColor: Colors.white,
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
      ),
      cardTheme: const CardTheme(
        surfaceTintColor: Colors.white,
      ),
      fontFamily: 'Murecho',
    );
  }
}
