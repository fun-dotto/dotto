import 'package:dotto/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/funch/domain/funch_menu_category.dart';

final class FunchDailyMenu {

  FunchDailyMenu(this.menuItems);
  final List<FunchMenu> menuItems;

  List<FunchMenu> getMenuByCategory(FunchMenuCategory category) {
    return menuItems.where((element) => category.categoryIds.contains(element.categoryId)).toList();
  }
}
