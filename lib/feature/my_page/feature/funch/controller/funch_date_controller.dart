import 'package:dotto/feature/my_page/feature/funch/repository/funch_repository.dart';
import 'package:dotto/importer.dart';

final funchDateProvider = NotifierProvider<FunchDateNotifier, DateTime>(() {
  return FunchDateNotifier();
});

class FunchDateNotifier extends Notifier<DateTime> {
  // 初期値を設定する
  @override
  DateTime build() {
    return FunchRepository().nextDay();
  }

  void set(DateTime dt) {
    state = dt;
  }

  void today() {
    state = DateTime.now();
  }
}
