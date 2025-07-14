import 'package:collection/collection.dart';
import 'package:dotto/feature/bus/bus.dart';
import 'package:dotto/feature/bus/controller/bus_controller.dart';
import 'package:dotto/feature/bus/widget/bus_card.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/theme/v1/animation.dart';
import 'package:dotto/widget/loading_circular.dart';

final class BusCardHome extends ConsumerWidget {
  const BusCardHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busData = ref.watch(busDataProvider);
    final myBusStop = ref.watch(myBusStopProvider);
    final busIsTo = ref.watch(busIsToProvider);
    final busRefresh = ref.watch(busRefreshProvider);
    final busIsWeekday = ref.watch(busIsWeekdayNotifier);

    final fromToString = busIsTo ? 'to_fun' : 'from_fun';

    if (busData != null) {
      final data =
          busData[fromToString]![busIsWeekday ? 'weekday' : 'holiday']!;
      for (final busTrip in data) {
        final funBusTripStop = busTrip.stops
            .firstWhereOrNull((element) => element.stop.id == 14023);
        if (funBusTripStop == null) {
          continue;
        }
        var targetBusTripStop = busTrip.stops
            .firstWhereOrNull((element) => element.stop.id == myBusStop.id);
        var kameda = false;
        if (targetBusTripStop == null) {
          targetBusTripStop =
              busTrip.stops.firstWhere((element) => element.stop.id == 14013);
          kameda = true;
        }
        final fromBusTripStop = busIsTo ? targetBusTripStop : funBusTripStop;
        final toBusTripStop = busIsTo ? funBusTripStop : targetBusTripStop;
        final now = busRefresh;
        final nowDuration = Duration(hours: now.hour, minutes: now.minute);
        final arriveAt = fromBusTripStop.time - nowDuration;
        if (arriveAt.isNegative) {
          continue;
        }
        return InkWell(
          onTap: () {
            ref.read(busScrolledProvider.notifier).state = false;
            Navigator.push(
              context,
              PageRouteBuilder<void>(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const BusScreen(),
                transitionsBuilder: fromRightAnimation,
              ),
            );
          },
          child: BusCard(
              busTrip.route, fromBusTripStop.time, toBusTripStop.time, arriveAt,
              isKameda: kameda, home: true),
        );
      }
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const BusScreen(),
            ),
          );
        },
        child: const BusCard('0', Duration.zero, Duration.zero, Duration.zero,
            home: true),
      );
    } else {
      return const LoadingCircular();
    }
  }
}
