import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'funch_date_controller.g.dart';

@riverpod
final class FunchDateNotifier extends _$FunchDateNotifier {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get value => state;

  set value(DateTime newValue) {
    state = newValue;
  }
}
