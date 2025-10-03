import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/bus/controller/bus_controller.dart';
import 'package:dotto/repository/user_preference_repository.dart';
import 'package:dotto/widget/loading_circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class BusStopSelectScreen extends ConsumerWidget {
  const BusStopSelectScreen({super.key});

  Future<void> setMyBusStop(int id) async {
    await UserPreferenceRepository.setInt(UserPreferenceKeys.myBusStop, id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBusStop = ref.watch(allBusStopsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('バス停選択')),
      body: allBusStop != null
          ? ListView(
              children: allBusStop
                  .where((busStop) => busStop.selectable ?? true)
                  .map(
                    (e) => ListTile(
                      onTap: () async {
                        final myBusStopNotifier = ref.read(
                          myBusStopProvider.notifier,
                        );
                        await UserPreferenceRepository.setInt(
                          UserPreferenceKeys.myBusStop,
                          e.id,
                        );
                        myBusStopNotifier.myBusStop = e;
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      title: Text(e.name),
                    ),
                  )
                  .toList(),
            )
          : const LoadingCircular(),
    );
  }
}
