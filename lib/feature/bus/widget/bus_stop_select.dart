import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/bus/controller/bus_stops_controller.dart';
import 'package:dotto/feature/bus/controller/my_bus_stop_controller.dart';
import 'package:dotto/repository/user_preference_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class BusStopSelectScreen extends ConsumerWidget {
  const BusStopSelectScreen({super.key});

  Future<void> setMyBusStop(int id) async {
    await UserPreferenceRepository.setInt(UserPreferenceKeys.myBusStop, id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busStops = ref.watch(busStopsNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('バス停選択')),
      body: busStops.when(
        data: (data) {
          return ListView(
            children: data
                .where((busStop) => busStop.selectable ?? true)
                .map(
                  (e) => ListTile(
                    onTap: () async {
                      await UserPreferenceRepository.setInt(
                        UserPreferenceKeys.myBusStop,
                        e.id,
                      );
                      ref.read(myBusStopNotifierProvider.notifier).value = e;
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    title: Text(e.name),
                  ),
                )
                .toList(),
          );
        },
        error: (error, stackTrace) => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
