import 'package:dotto/domain/timetable.dart';
import 'package:dotto/feature/bus/controller/bus_is_to_controller.dart';
import 'package:dotto/feature/bus/controller/bus_polling_controller.dart';
import 'package:dotto/helper/location_helper.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class HomeService {
  HomeService(this.ref);

  final Ref ref;

  Future<List<Timetable>> getTimetables() async {
    return ref.read(timetableRepositoryProvider).getTimetables();
  }

  void startBusPolling() {
    ref.read(busPollingProvider.notifier).start();
  }

  // TODO: Refactor
  Future<void> changeDirectionOnCurrentLocation() async {
    final locationHelper = ref.read(locationHelperProvider);
    final position = await locationHelper.determinePosition();
    if (position != null) {
      final latitude = position.latitude;
      if (latitude > 41.838770 && latitude < 41.845295) {
        final longitude = position.longitude;
        if (longitude > 140.765061 && longitude < 140.770368) {
          ref.read(busIsToProvider.notifier).toggle();
        }
      }
    }
  }
}
