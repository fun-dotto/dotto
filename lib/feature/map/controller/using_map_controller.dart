import 'package:dotto/feature/map/repository/map_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'using_map_controller.g.dart';

@riverpod
class UsingMapNotifier extends _$UsingMapNotifier {
  @override
  Map<String, bool> build() {
    return {};
  }

  Future<void> setUsingColor(DateTime dateTime, WidgetRef ref) async {
    state = await MapRepository().setUsingColor(dateTime, ref);
  }
}
