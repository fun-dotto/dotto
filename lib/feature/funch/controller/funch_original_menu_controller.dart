import 'package:dotto/feature/funch/domain/funch_menu.dart';
import 'package:dotto/importer.dart';

// watchしない可能性あり
final funchAllOriginalMenuProvider =
    NotifierProvider<FunchOriginalMenuNotifier, List<FunchOriginalMenu>?>(
        () => FunchOriginalMenuNotifier());

class FunchOriginalMenuNotifier extends Notifier<List<FunchOriginalMenu>?> {
  @override
  List<FunchOriginalMenu>? build() {
    return null;
  }

  void set(List<FunchOriginalMenu> list) {
    state = list;
  }
}
