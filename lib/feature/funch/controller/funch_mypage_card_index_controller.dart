import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'funch_mypage_card_index_controller.g.dart';

@riverpod
final class FunchMyPageCardIndexNotifier extends _$FunchMyPageCardIndexNotifier {
  @override
  int build() {
    return 0;
  }

  int get value => state;

  set value(int newValue) {
    state = newValue;
  }
}
