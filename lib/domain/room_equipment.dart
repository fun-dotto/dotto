import 'package:flutter/material.dart';

final class RoomEquipmentStatus {
  const RoomEquipmentStatus({required this.food, required this.drink, required this.outlet});

  final RoomEquipmentFood food;
  final RoomEquipmentDrink drink;
  final RoomEquipmentOutlet outlet;
}

enum RoomEquipmentQuality {
  unknown(icon: Icons.help_outline),
  unavailable(icon: Icons.close_outlined),
  limited(icon: Icons.change_history_outlined),
  available(icon: Icons.circle_outlined);

  const RoomEquipmentQuality({required this.icon});

  final IconData icon;
}

abstract class RoomEquipment {
  const RoomEquipment({required this.label, required this.icon, required this.quality});

  final String label;
  final IconData icon;
  final RoomEquipmentQuality quality;
}

final class RoomEquipmentFood extends RoomEquipment {
  RoomEquipmentFood({required super.quality, super.label = '食べ物', super.icon = Icons.lunch_dining});
}

final class RoomEquipmentDrink extends RoomEquipment {
  RoomEquipmentDrink({required super.quality, super.label = '飲み物', super.icon = Icons.local_drink});
}

final class RoomEquipmentOutlet extends RoomEquipment {
  RoomEquipmentOutlet({required super.quality, super.label = 'コンセント', super.icon = Icons.electrical_services});
}
