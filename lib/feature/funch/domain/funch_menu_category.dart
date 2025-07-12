import 'package:dotto/importer.dart';

enum FunchMenuCategory {
  set("セット・単品", [1, 7, 8], Icons.restaurant),
  donCurry("丼・カレー", [4, 5], Icons.rice_bowl),
  noodle("麺", [11], Icons.ramen_dining),
  sideDish("副菜", [2, 9], Icons.eco),
  dessert("デザート", [3], Icons.cake);

  final String title;
  final List<int> categoryIds;
  final IconData icon;

  const FunchMenuCategory(this.title, this.categoryIds, this.icon);
}
