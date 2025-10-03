import 'package:collection/collection.dart';
import 'package:dotto/feature/bus/bus.dart';
import 'package:dotto/feature/bus/controller/bus_data_controller.dart';
import 'package:dotto/feature/bus/controller/bus_is_scrolled_controller.dart';
import 'package:dotto/feature/bus/controller/bus_is_to_controller.dart';
import 'package:dotto/feature/bus/controller/bus_is_weekday_controller.dart';
import 'package:dotto/feature/bus/controller/bus_polling_controller.dart';
import 'package:dotto/feature/bus/controller/my_bus_stop_controller.dart';
import 'package:dotto/feature/bus/widget/bus_card.dart';
import 'package:dotto/theme/v1/animation.dart';
import 'package:dotto/widget/loading_circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class BusCardHome extends ConsumerWidget {
  const BusCardHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busData = ref.watch(busDataNotifierProvider);
    final myBusStop = ref.watch(myBusStopNotifierProvider);
    final busIsTo = ref.watch(busIsToNotifierProvider);
    final busPolling = ref.watch(busPollingNotifierProvider);
    final busIsWeekday = ref.watch(busIsWeekdayNotifierProvider);

    final fromToString = busIsTo ? 'to_fun' : 'from_fun';

    return busData.when(
      data: (data) {
        final dataOfDay =
            data[fromToString]![busIsWeekday ? 'weekday' : 'holiday']!;
        for (final busTrip in dataOfDay) {
          final funBusTripStop = busTrip.stops.firstWhereOrNull(
            (element) => element.stop.id == 14023,
          );
          if (funBusTripStop == null) {
            continue;
          }
          var targetBusTripStop = busTrip.stops.firstWhereOrNull(
            (element) => element.stop.id == myBusStop.id,
          );
          var kameda = false;
          if (targetBusTripStop == null) {
            targetBusTripStop = busTrip.stops.firstWhere(
              (element) => element.stop.id == 14013,
            );
            kameda = true;
          }
          final fromBusTripStop = busIsTo ? targetBusTripStop : funBusTripStop;
          final toBusTripStop = busIsTo ? funBusTripStop : targetBusTripStop;
          final now = busPolling;
          final nowDuration = Duration(hours: now.hour, minutes: now.minute);
          final arriveAt = fromBusTripStop.time - nowDuration;
          if (arriveAt.isNegative) {
            continue;
          }
          return InkWell(
            onTap: () {
              ref.read(busIsScrolledNotifierProvider.notifier).value = false;
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
              busTrip.route,
              fromBusTripStop.time,
              toBusTripStop.time,
              arriveAt,
              isKameda: kameda,
              home: true,
            ),
          );
        }
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (context) => const BusScreen()),
            );
          },
          child: const BusCard(
            '0',
            Duration.zero,
            Duration.zero,
            Duration.zero,
            home: true,
          ),
        );
      },
      error: (error, _) {
        return const SizedBox.shrink();
      },
      loading: () => const LoadingCircular(),
    );
  }
}
