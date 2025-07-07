import 'package:dotto/feature/funch/domain/funch_menu_type.dart';
import 'package:dotto/importer.dart';

final funchMenuTypeProvider = NotifierProvider<FunchMenuTypeNotifier, FunchMenuType>(() {
  return FunchMenuTypeNotifier();
});

class FunchMenuTypeNotifier extends Notifier<FunchMenuType> {
  // 初期値を設定する
  @override
  FunchMenuType build() {
    final category = FunchMenuType.set;
    return category;
  }

  void set(FunchMenuType type) {
    state = type;
  }
}

final funchMyPageIndexProvider = StateProvider((ref) => 0);
