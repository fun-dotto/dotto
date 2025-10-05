import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<bool> courseCancellationFilterEnabledProvider =
    StateProvider((ref) => true);
final StateProvider<String> courseCancellationSelectedTypeProvider =
    StateProvider((ref) => 'すべて');
