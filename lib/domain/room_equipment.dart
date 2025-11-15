import 'package:flutter/material.dart';

enum RoomEquipment {
  outlet(label: 'コンセント', icon: Icons.electrical_services),
  food(label: '食べ物', icon: Icons.lunch_dining),
  drink(label: '飲み物', icon: Icons.local_drink);

  const RoomEquipment({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
