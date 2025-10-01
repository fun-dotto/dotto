import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class LoadingCircular extends StatelessWidget {
  const LoadingCircular({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: SemanticColor.light.accentPrimary,
      ),
    );
  }
}
