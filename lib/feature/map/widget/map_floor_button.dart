import 'package:dotto/domain/floor.dart';
import 'package:dotto/theme/v1/color_fun.dart';
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
        backgroundColor: selectedFloor == floor ? Colors.black12 : null,
      ),
      onPressed: () {
        onPressed(floor);
      },
      child: Text(
        floor.label,
        style: TextStyle(
          fontSize: 18,
          color: selectedFloor == floor ? customFunColor : Colors.black87,
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
