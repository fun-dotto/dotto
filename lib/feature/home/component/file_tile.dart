import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class FileTile extends StatelessWidget {
  const FileTile({
    required this.title,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SemanticColor.light.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SemanticColor.light.borderPrimary),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: SemanticColor.light.accentPrimary),
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: SemanticColor.light.labelSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
