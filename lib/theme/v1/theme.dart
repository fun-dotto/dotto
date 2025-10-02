import 'package:dotto/theme/v1/color_fun.dart';
import 'package:flutter/material.dart';

final class DottoThemev1 {
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: customFunColor,
      colorScheme: ColorScheme.light(
        primary: customFunColor,
        onSurface: Colors.grey.shade900,
        surface: Colors.grey.shade100,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          elevation: const WidgetStatePropertyAll(2),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      appBarTheme: const AppBarTheme(foregroundColor: customFunColor),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade200),
      cardTheme: const CardThemeData(surfaceTintColor: Colors.white),
      fontFamily: 'Murecho',
    );
  }
}
