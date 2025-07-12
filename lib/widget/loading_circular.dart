import 'package:dotto/theme/importer.dart';
import 'package:flutter/material.dart';

final class LoadingCircular extends StatelessWidget {
  const LoadingCircular({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        color: SemanticColors.primaryMain,
      ),
    );
  }
}
