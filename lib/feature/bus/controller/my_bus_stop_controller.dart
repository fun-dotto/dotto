import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/bus/domain/bus_stop.dart';
import 'package:dotto/feature/bus/repository/bus_repository.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'my_bus_stop_controller.g.dart';

@riverpod
final class MyBusStopNotifier extends _$MyBusStopNotifier {
  @override
  BusStop build() {
    return const BusStop(14013, '亀田支所前', ['50', '55', '55A', '55B', '55C', '55E', '55F', '55G', '55H']);
  }

  BusStop get value => state;

  set value(BusStop newValue) {
    state = newValue;
  }

  Future<void> load() async {
    final myBusStopPreference = await UserPreferenceRepository.getInt(UserPreferenceKeys.myBusStop);
    final busStops = await BusRepository().getAllBusStopsFromFirebase();
    state = busStops.firstWhere((busStop) => busStop.id == (myBusStopPreference ?? 14013));
  }
}
