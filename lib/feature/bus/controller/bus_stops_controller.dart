import 'package:dotto/feature/bus/domain/bus_stop.dart';
import 'package:dotto/feature/bus/repository/bus_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'bus_stops_controller.g.dart';

@riverpod
final class BusStopsNotifier extends _$BusStopsNotifier {
  @override
  Future<List<BusStop>> build() async {
    return BusRepository().getAllBusStopsFromFirebase();
  }
}
