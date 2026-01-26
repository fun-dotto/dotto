import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class LinkTile extends StatelessWidget {
  const LinkTile({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String title;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SemanticColor.light.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SemanticColor.light.borderPrimary),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Row(
            spacing: 8,
            children: [
              Image.network(icon, width: 16, height: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SemanticColor.light.labelPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: SemanticColor.light.labelSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
