import 'package:dotto/feature/bus/domain/bus_stop.dart';

class BusTripStop {
  const BusTripStop(this.time, this.stop, {this.terminal});

  factory BusTripStop.fromFirebase(BusStop stop, Map map) {
    final timeStrList = (map['time'] as String).split(':');
    final hour = int.parse(timeStrList[0] as String);
    final minute = int.parse(timeStrList[1]);
    return BusTripStop(Duration(hours: hour, minutes: minute), stop, terminal: map['terminal'] as int?);
  }
  final Duration time;
  final BusStop stop;
  final int? terminal;
}

class BusTrip {

  const BusTrip(this.route, this.stops);

  factory BusTrip.fromFirebase(Map map, List<BusStop> allStops) {
    final stopsList = map['stops'] as List;
    return BusTrip(
        map['route'] as String,
        stopsList.map(
          (e) {
            final int id = e['id'] as int;
            final targetBusStop = allStops.firstWhere((busStop) => busStop.id == id);
            return BusTripStop.fromFirebase(targetBusStop, e as Map);
          },
        ).toList());
  }
  final String route;
  final List<BusTripStop> stops;
}
