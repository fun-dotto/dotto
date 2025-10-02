import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

extension DottoColorExtension on ThemeData {
  SemanticColor get semanticColors => extension<SemanticColor>()!;
}
