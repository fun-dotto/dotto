import 'package:dotto/feature/bus/domain/bus_stop.dart';

final class BusTripStop {
  const BusTripStop(this.time, this.stop, {this.terminal});

  factory BusTripStop.fromFirebase(BusStop stop, Map<String, dynamic> map) {
    final timeStrList = (map['time'] as String).split(':');
    final hour = int.parse(timeStrList[0]);
    final minute = int.parse(timeStrList[1]);
    return BusTripStop(Duration(hours: hour, minutes: minute), stop,
        terminal: map['terminal'] as int?);
  }
  final Duration time;
  final BusStop stop;
  final int? terminal;
}

final class BusTrip {
  const BusTrip(this.route, this.stops);

  factory BusTrip.fromFirebase(
    Map<String, dynamic> map,
    List<BusStop> allStops,
  ) {
    final stopsList = map['stops'] as List;
    return BusTrip(
        map['route'] as String,
        stopsList.map(
          (e) {
            final stopMap = Map<String, dynamic>.from(e as Map);
            final id = stopMap['id'] as int;
            final targetBusStop =
                allStops.firstWhere((busStop) => busStop.id == id);
            return BusTripStop.fromFirebase(
              targetBusStop,
              stopMap,
            );
          },
        ).toList());
  }
  final String route;
  final List<BusTripStop> stops;
}
