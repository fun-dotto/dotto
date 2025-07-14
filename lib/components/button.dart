import 'package:dotto/importer.dart';

class ContainedElevatedButtons {
  ElevatedButton containedButton = ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF990000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    child: Text(
      "Button",
      style: TextStyle(color: Colors.white),
    ),
  );
}
