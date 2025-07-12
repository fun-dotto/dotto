import 'package:dotto/feature/funch/domain/funch_menu_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final funchMenuCategoryProvider =
    NotifierProvider<FunchMenuCategoryNotifier, FunchMenuCategory>(() {
  return FunchMenuCategoryNotifier();
});

class FunchMenuCategoryNotifier extends Notifier<FunchMenuCategory> {
  // 初期値を設定する
  @override
  FunchMenuCategory build() {
    final category = FunchMenuCategory.set;
    return category;
  }

  void set(FunchMenuCategory type) {
    state = type;
  }
}
