import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/controller/tab_controller.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/tab_item.dart';
import 'package:dotto/feature/map/controller/map_controller.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/feature/map/domain/map_room_available_type.dart';
import 'package:dotto/feature/map/widget/fun_grid_map.dart';
import 'package:dotto/feature/map/widget/map_tile.dart';
import 'package:dotto/importer.dart';
import 'package:intl/intl.dart';

class MapDetailBottomSheet extends ConsumerWidget {
  const MapDetailBottomSheet({super.key, required this.floor, required this.roomName});
  final String floor;
  final String roomName;

  static const Color blue = Color(0xFF4A90E2);

  Widget scheduleTile(BuildContext context, DateTime begin, DateTime end, String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            width: 5,
            color: blue,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            title,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('MM/dd').format(begin),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                "${DateFormat('HH:mm').format(begin)} ~ ${DateFormat('HH:mm').format(end)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          )
          // time
        ],
      ),
    );
  }

  Widget roomAvailable(RoomAvailableType type, int status) {
    const fontColor = Colors.white;
    IconData icon = Icons.close_outlined;
    if (status == 1) {
      icon = Icons.change_history_outlined;
    } else if (status == 2) {
      icon = Icons.circle_outlined;
    }
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: blue.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            type.icon,
            color: fontColor,
            size: 20,
          ),
          Text(
            type.title,
            style: const TextStyle(
              color: fontColor,
            ),
          ),
          Icon(
            icon,
            color: fontColor,
            size: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapDetailMap = ref.watch(mapDetailMapProvider);
    final searchDatetime = ref.watch(searchDatetimeProvider);
    final user = ref.watch(userProvider);
    String roomTitle = roomName;
    MapDetail? mapDetail;
    bool loading = false;
    if (user != null) {
      mapDetailMap.when(
        data: (data) {
          loading = false;
          mapDetail = data.searchOnce(floor, roomName);
          if (mapDetail != null) {
            roomTitle = mapDetail!.header;
          }
        },
        error: (error, stackTrace) {},
        loading: () {
          loading = true;
        },
      );
    }
    MapTile? gridMap;
    try {
      gridMap = FunGridMaps.mapTileListMap[floor]!.firstWhere((element) => element.txt == roomName);
    } catch (e) {
      gridMap = null;
    }
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Color(0xFFF2F9FF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 2.0,
            blurRadius: 8.0,
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SelectableText(
                    roomTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minHeight: 40,
                      minWidth: 40,
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
          user != null
              ? !loading
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (gridMap != null) ...[
                              SizedBox(
                                height: 5,
                              ),
                              Wrap(
                                spacing: 10,
                                children: [
                                  if (gridMap.food != null && gridMap.drink != null) ...[
                                    roomAvailable(RoomAvailableType.food, gridMap.food! ? 2 : 0),
                                    roomAvailable(RoomAvailableType.drink, gridMap.drink! ? 2 : 0),
                                  ],
                                  if (gridMap.outlet != null)
                                    roomAvailable(RoomAvailableType.outlet, gridMap.outlet!),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                            if (mapDetail != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (mapDetail!.scheduleList != null)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ...mapDetail!.getScheduleListByDate(searchDatetime).map(
                                              (e) => scheduleTile(context, e.begin, e.end, e.title),
                                            ),
                                      ],
                                    )
                                  else if (mapDetail!.detail != null)
                                    SelectableText(mapDetail!.detail!),
                                  if (mapDetail!.mail != null)
                                    SelectableText('${mapDetail!.mail}@fun.ac.jp'),
                                ],
                              ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Center(
                        child: createProgressIndicator(),
                      ),
                    )
              : Column(
                  children: [
                    const Text("詳細は未来大Googleアカウントでログインすることで表示できます。"),
                    OutlinedButton(
                      onPressed: () {
                        final tabItemNotifier = ref.read(tabItemProvider.notifier);
                        tabItemNotifier.selected(TabItem.setting);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text("設定"),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
