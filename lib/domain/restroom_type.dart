import 'package:dotto/domain/map_colors.dart';
import 'package:flutter/material.dart';

enum RestroomType {
  men(icon: Icons.man, color: MapColors.restroomMen),
  women(icon: Icons.woman, color: MapColors.restroomWomen),
  multipurpose(icon: Icons.accessible, color: Colors.black),
  kitchenette(icon: Icons.countertops, color: Colors.black);

  const RestroomType({required this.icon, this.color});

  final IconData icon;
  final Color? color;
}
