import 'package:dotto/feature/bus/domain/bus_trip.dart';
import 'package:dotto/feature/bus/repository/bus_repository.dart';
import 'package:dotto/importer.dart';

final class BusTimetableScreen extends StatelessWidget {
  const BusTimetableScreen(this.busTrip, {super.key});
  final BusTrip busTrip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${busTrip.route} 時刻表'),
      ),
      body: ListView(
        children: busTrip.stops.map((busTripStop) {
          final terminal = busTripStop.terminal;
          return ListTile(
            title: Text(busTripStop.stop.name),
            trailing: Text(
              BusRepository().formatDuration(busTripStop.time),
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: terminal != null ? Text('$terminal番乗り場') : null,
          );
        }).toList(),
      ),
    );
  }
}
