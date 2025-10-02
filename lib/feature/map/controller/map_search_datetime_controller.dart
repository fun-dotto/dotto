import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'map_search_datetime_controller.g.dart';

@riverpod
class MapSearchDatetimeNotifier extends _$MapSearchDatetimeNotifier {
  @override
  DateTime build() {
    return DateTime.now();
  }

  DateTime get value => state;

  set value(DateTime newValue) {
    state = newValue;
  }
}
