import 'package:flutter/material.dart';

enum TabItem {
  home(
    key: 'home',
    title: 'ホーム',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
  ),
  map(
    key: 'map',
    title: 'マップ',
    icon: Icons.map_outlined,
    activeIcon: Icons.map,
  ),
  course(
    key: 'course',
    title: '科目',
    icon: Icons.search_outlined,
    activeIcon: Icons.search,
  ),
  assignment(
    key: 'assignment',
    title: '課題',
    icon: Icons.assignment_outlined,
    activeIcon: Icons.assignment,
  ),
  setting(
    key: 'setting',
    title: '設定',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
  );

  const TabItem({
    required this.key,
    required this.title,
    required this.icon,
    required this.activeIcon,
  });

  final String key;
  final String title;
  final IconData icon;
  final IconData activeIcon;
}
