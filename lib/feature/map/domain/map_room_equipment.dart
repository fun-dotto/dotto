import 'package:flutter/material.dart';

enum MapRoomEquipment {
  food(label: '食べ物', icon: Icons.lunch_dining),
  drink(label: '飲み物', icon: Icons.local_drink),
  outlet(label: 'コンセント', icon: Icons.electrical_services);

  const MapRoomEquipment({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
