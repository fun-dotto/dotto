import 'package:dotto/feature/assignment/assignment_list_screen.dart';
import 'package:dotto/feature/home/home.dart';
import 'package:dotto/feature/map/map_screen.dart';
import 'package:dotto/feature/search_course/search_course_screen.dart';
import 'package:dotto/feature/setting/settings.dart';
import 'package:flutter/material.dart';

enum TabItem {
  home(
    key: 'home',
    title: 'ホーム',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    page: HomeScreen(),
  ),
  map(
    key: 'map',
    title: 'マップ',
    icon: Icons.map_outlined,
    activeIcon: Icons.map,
    page: MapScreen(),
  ),
  kamoku(
    key: 'course',
    title: '科目',
    icon: Icons.search_outlined,
    activeIcon: Icons.search,
    page: SearchCourseScreen(),
  ),
  kadai(
    key: 'assignment',
    title: '課題',
    icon: Icons.assignment_outlined,
    activeIcon: Icons.assignment,
    page: AssignmentListScreen(),
  ),
  setting(
    key: 'setting',
    title: '設定',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    page: SettingsScreen(),
  );

  const TabItem({
    required this.key,
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.page,
  });

  final String key;
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;
}

final Map<TabItem, GlobalKey<NavigatorState>> tabNavigatorKeyMaps = {
  TabItem.home: GlobalKey<NavigatorState>(),
  TabItem.map: GlobalKey<NavigatorState>(),
  TabItem.kamoku: GlobalKey<NavigatorState>(),
  TabItem.kadai: GlobalKey<NavigatorState>(),
};
