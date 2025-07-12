import 'package:flutter_riverpod/flutter_riverpod.dart';

final funchDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});
