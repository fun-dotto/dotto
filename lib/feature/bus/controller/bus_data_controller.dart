import 'package:dotto/feature/bus/domain/bus_trip.dart';
import 'package:dotto/feature/bus/repository/bus_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'bus_data_controller.g.dart';

/// Map&lt;String, Map&lt;String, List&lt;BusTrip&gt;&gt;&gt;
/// 1つ目のStringキー: from_fun, to_fun
/// 2つ目のStringキー: holiday, weekday
@riverpod
final class BusDataNotifier extends _$BusDataNotifier {
  @override
  Future<Map<String, Map<String, List<BusTrip>>>> build() async {
    final busStops = await BusRepository().getAllBusStopsFromFirebase();
    return BusRepository().getBusDataFromFirebase(busStops);
  }
}
