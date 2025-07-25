import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/map/controller/map_controller.dart';
import 'package:dotto/feature/map/domain/map_tile_type.dart';
import 'package:dotto/feature/map/repository/map_repository.dart';
import 'package:dotto/feature/map/widget/map_tile.dart';
import 'package:dotto/importer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

final class MapBottomInfo extends ConsumerWidget {
  const MapBottomInfo({super.key});

  Widget _mapInfoTile(Color color, String text) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(color: color, border: Border.all()),
          width: 11,
          height: 11,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return const SizedBox();
    }
    const double floorButtonHeight = 45;
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
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 75,
            width: 245,
            color: Colors.grey.shade400.withValues(alpha: 0.6),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _mapInfoTile(MapColors.using, '下記設定時間に授業等で使用中の部屋'),
                _mapInfoTile(MapTileType.wc.backgroundColor, 'トイレ及び給湯室'),
                _mapInfoTile(Colors.red, '検索結果'),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
              height: floorButtonHeight,
              color: Colors.grey.shade400.withValues(alpha: 0.8),
              alignment: Alignment.centerLeft,
              child: Consumer(
                builder: (context, ref, child) {
                  final searchDatetime = ref.watch(searchDatetimeProvider);
                  final searchDatetimeNotifier =
                      ref.read(searchDatetimeProvider.notifier);
                  final mapUsingMapNotifier =
                      ref.watch(mapUsingMapProvider.notifier);
                  return Row(
                    children: [
                      ...timeMap.entries.map((item) => Expanded(
                            child: Center(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                onPressed: () async {
                                  var setDate = item.value;
                                  if (setDate.hour == 0) {
                                    setDate = DateTime.now();
                                  }
                                  searchDatetimeNotifier.datetime = setDate;
                                  mapUsingMapNotifier.state =
                                      await MapRepository()
                                          .setUsingColor(setDate, ref);
                                },
                                child: Center(
                                  child: Text(item.key),
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            onPressed: () {
                              DatePicker.showDateTimePicker(
                                context,
                                minTime: monday,
                                maxTime: nextSunday,
                                onConfirm: (date) async {
                                  searchDatetimeNotifier.datetime = date;
                                  mapUsingMapNotifier.state =
                                      await MapRepository()
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
                                Text(DateFormat('MM月dd日')
                                    .format(searchDatetime)),
                                Text(
                                    DateFormat('HH:mm').format(searchDatetime)),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ],
      ),
    );
  }
}
