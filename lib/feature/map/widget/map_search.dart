import 'package:dotto/feature/map/controller/focused_map_detail_controller.dart';
import 'package:dotto/feature/map/controller/map_detail_map_controller.dart';
import 'package:dotto/feature/map/controller/map_page_controller.dart';
import 'package:dotto/feature/map/controller/map_search_bar_focus_controller.dart';
import 'package:dotto/feature/map/controller/map_search_text_controller.dart';
import 'package:dotto/feature/map/controller/map_view_transformation_controller.dart';
import 'package:dotto/feature/map/controller/on_map_search_controller.dart';
import 'package:dotto/feature/map/controller/search_list_controller.dart';
import 'package:dotto/feature/map/widget/map_detail_bottom_sheet.dart';
import 'package:dotto/importer.dart';

final class MapSearchBar extends ConsumerWidget {
  const MapSearchBar({super.key});

  void _onSearchQueryChanged(WidgetRef ref, String text) {
    final mapSearchListNotifier = ref.read(
      mapSearchListNotifierProvider.notifier,
    );
    final onMapSearchNotifier = ref.read(onMapSearchNotifierProvider.notifier);
    final mapDetailMap = ref.watch(mapDetailMapNotifierProvider);
    if (text.isEmpty) {
      onMapSearchNotifier.value = false;
      mapSearchListNotifier.list = [];
    } else {
      onMapSearchNotifier.value = true;
      mapDetailMap.whenData((data) {
        mapSearchListNotifier.list = data.searchAll(text);
      });
    }
  }

  /// サーチバーのテキストフィールド
  Widget _mapSearchTextField(WidgetRef ref) {
    final textEditingController = ref.watch(mapSearchTextNotifierProvider);
    final mapSearchBarFocus = ref.watch(mapSearchBarFocusNotifierProvider);
    final onMapSearchNotifier = ref.read(onMapSearchNotifierProvider.notifier);
    final mapSearchListNotifier = ref.read(
      mapSearchListNotifierProvider.notifier,
    );
    return TextField(
      controller: textEditingController,
      focusNode: mapSearchBarFocus,
      decoration: InputDecoration(
        hintText: '部屋名、教員名、メールアドレスなどで検索',
        suffixIcon: textEditingController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  mapSearchListNotifier.list = [];
                  onMapSearchNotifier.value = false;
                  textEditingController.clear();
                },
              )
            : null,
      ),
      onChanged: (text) {
        _onSearchQueryChanged(ref, text);
      },
      onSubmitted: (text) {
        _onSearchQueryChanged(ref, text);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapSearchList = ref.watch(mapSearchListNotifierProvider);
    return Container(
      color: (mapSearchList.isNotEmpty)
          ? Colors.white.withValues(alpha: 0.9)
          : Colors.transparent,
      margin: const EdgeInsets.only(top: 15, right: 5, left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: _mapSearchTextField(ref),
    );
  }
}

/// 背景の色を設定
final class MapBarrierOnSearch extends ConsumerWidget {
  const MapBarrierOnSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapSearchList = ref.watch(mapSearchListNotifierProvider);
    final mapSearchListNotifier = ref.read(
      mapSearchListNotifierProvider.notifier,
    );
    if (mapSearchList.isNotEmpty) {
      return ColoredBox(
        color: Colors.white.withValues(alpha: 0.9),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: const SizedBox.expand(),
          onTap: () {
            mapSearchListNotifier.list = [];
          },
        ),
      );
    } else {
      return Container();
    }
  }
}

/// 検索予測結果
final class MapSearchListView extends ConsumerWidget {
  const MapSearchListView({super.key});

  static const List<String> floorBarString = [
    '1',
    '2',
    '3',
    '4',
    '5',
    'R6',
    'R7',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapSearchList = ref.watch(mapSearchListNotifierProvider);
    final mapSearchListNotifier = ref.read(
      mapSearchListNotifierProvider.notifier,
    );
    final mapPageNotifier = ref.watch(mapPageNotifierProvider.notifier);
    final focusedMapDetailNotifier = ref.watch(
      focusedMapDetailNotifierProvider.notifier,
    );
    final mapViewTransformationNotifier = ref.read(
      mapViewTransformationNotifierProvider.notifier,
    );
    final mapSearchBarFocusNotifier = ref.watch(
      mapSearchBarFocusNotifierProvider,
    );
    if (mapSearchList.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('検索結果'),
            Flexible(
              child: ListView.separated(
                itemCount: mapSearchList.length,
                itemBuilder: (context, int index) {
                  final item = mapSearchList[index];
                  return ListTile(
                    onTap: () {
                      mapSearchListNotifier.list = [];
                      FocusScope.of(context).unfocus();
                      mapViewTransformationNotifier.value.value.setIdentity();
                      focusedMapDetailNotifier.value = item;
                      mapPageNotifier.value = floorBarString.indexOf(
                        item.floor,
                      );
                      showBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return MapDetailBottomSheet(
                            floor: item.floor,
                            roomName: item.roomName,
                          );
                        },
                      );
                      mapSearchBarFocusNotifier.unfocus();
                    },
                    title: Text(item.header),
                    leading: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        const Icon(Icons.search),
                        Text('${item.floor}階'),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  );
                },
                separatorBuilder: (context, index) => const Divider(height: 1),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
