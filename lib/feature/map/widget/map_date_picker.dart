import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/map/controller/map_search_datetime_controller.dart';
import 'package:dotto/feature/map/controller/using_map_controller.dart';
import 'package:dotto/theme/v1/color_fun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final class MapDatePicker extends ConsumerWidget {
  const MapDatePicker({super.key});

  Widget _periodButton(WidgetRef ref, String label, DateTime dateTime) {
    final mapSearchDatetime = ref.watch(mapSearchDatetimeNotifierProvider);

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: mapSearchDatetime == dateTime ? Colors.black12 : null,
        textStyle: const TextStyle(fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      onPressed: () async {
        var setDate = dateTime;
        if (setDate.hour == 0) {
          setDate = DateTime.now();
        }
        ref.read(mapSearchDatetimeNotifierProvider.notifier).value = setDate;
        await ref
            .read(usingMapNotifierProvider.notifier)
            .setUsingColor(setDate, ref);
      },
      child: Text(
        label,
        style: TextStyle(
          color: mapSearchDatetime == dateTime
              ? customFunColor
              : Colors.black87,
        ),
      ),
    );
  }

  Widget _datePickerButton(
    BuildContext context,
    WidgetRef ref,
    DateTime searchDatetime,
    DateTime monday,
    DateTime nextSunday,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          minTime: monday,
          maxTime: nextSunday,
          onConfirm: (date) async {
            ref.read(mapSearchDatetimeNotifierProvider.notifier).value = date;
            await ref
                .read(usingMapNotifierProvider.notifier)
                .setUsingColor(date, ref);
          },
          currentTime: searchDatetime,
          locale: LocaleType.jp,
        );
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat('MM月dd日').format(searchDatetime)),
            Text(DateFormat('HH:mm').format(searchDatetime)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return const SizedBox();
    }

    final searchDatetime = ref.watch(mapSearchDatetimeNotifierProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final nextSunday = monday.add(const Duration(days: 14, minutes: -1));
    final timeMap = <String, DateTime>{
      '1限': today.add(const Duration(hours: 9)),
      '2限': today.add(const Duration(hours: 10, minutes: 40)),
      '3限': today.add(const Duration(hours: 13, minutes: 10)),
      '4限': today.add(const Duration(hours: 14, minutes: 50)),
      '5限': today.add(const Duration(hours: 16, minutes: 30)),
      '現在': today,
    };

    return Row(
      children: [
        ...timeMap.entries.map(
          (item) => Expanded(
            child: Center(child: _periodButton(ref, item.key, item.value)),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: _datePickerButton(
              context,
              ref,
              searchDatetime,
              monday,
              nextSunday,
            ),
          ),
        ),
      ],
    );
  }
}
