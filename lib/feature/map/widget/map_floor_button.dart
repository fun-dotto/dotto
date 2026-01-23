import 'package:dotto/domain/floor.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class MapFloorButton extends StatelessWidget {
  const MapFloorButton({
    required this.selectedFloor,
    required this.onPressed,
    super.key,
  });

  final Floor selectedFloor;
  final void Function(Floor) onPressed;

  Widget _floorButton(BuildContext context, Floor floor) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: selectedFloor == floor
            ? SemanticColor.light.backgroundTertiary
            : null,
      ),
      onPressed: () {
        onPressed(floor);
      },
      child: Text(
        floor.label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: selectedFloor == floor
              ? SemanticColor.light.accentPrimary
              : SemanticColor.light.labelSecondary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: Floor.values.length,
      children: List.generate(Floor.values.length, (index) {
        return _floorButton(context, Floor.values[index]);
      }),
    );
  }
}
