import 'package:dotto/feature/funch/domain/funch_menu_category.dart';
import 'package:dotto/importer.dart';

final funchMenuTypeProvider = NotifierProvider<FunchMenuTypeNotifier, FunchMenuCategory>(() {
  return FunchMenuTypeNotifier();
});

class FunchMenuTypeNotifier extends Notifier<FunchMenuCategory> {
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

final funchMyPageIndexProvider = StateProvider((ref) => 0);
