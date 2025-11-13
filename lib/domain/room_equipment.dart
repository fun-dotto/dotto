import 'package:flutter/material.dart';

enum RoomEquipment {
  outlet(Icons.electrical_services, 'コンセント'),
  food(Icons.lunch_dining, '食べ物'),
  drink(Icons.local_drink, '飲み物');

  const RoomEquipment(this.icon, this.title);

  final IconData icon;
  final String title;
}
