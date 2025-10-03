import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'bus_polling_controller.g.dart';

@riverpod
final class BusPollingNotifier extends _$BusPollingNotifier {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void start() {
    Timer.periodic(const Duration(seconds: 30), (_) async {
      state = DateTime.now();
    });
  }
}
