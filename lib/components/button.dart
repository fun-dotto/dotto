import 'package:dotto/importer.dart';

class ContainedElevatedButtons {
  ElevatedButton containedButton({
    required VoidCallback onPressed,
    required Widget child,
    Color backgroundColor = const Color(0xFF990000),
    Color foregroundColor = Colors.white,
  }) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        child: child);
  }
}
