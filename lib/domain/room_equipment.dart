import 'package:flutter/material.dart';

enum RoomEquipment {
  outlet(icon: Icons.electrical_services, title: 'コンセント'),
  food(icon: Icons.lunch_dining, title: '食べ物'),
  drink(icon: Icons.local_drink, title: '飲み物');

  const RoomEquipment({required this.icon, required this.title});

  final IconData icon;
  final String title;
}
