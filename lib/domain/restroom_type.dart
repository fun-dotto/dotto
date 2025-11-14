import 'package:flutter/material.dart';

enum RestroomType {
  men(icon: Icons.man, color: Colors.blue),
  women(icon: Icons.woman, color: Colors.red),
  wheelchair(icon: Icons.accessible);

  const RestroomType({required this.icon, this.color});

  final IconData icon;
  final Color? color;
}
