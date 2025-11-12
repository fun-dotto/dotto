import 'package:dotto/feature/map/controller/map_search_text_controller.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/feature/map/domain/map_detail_map.dart';
import 'package:dotto/feature/map/repository/map_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'map_search_result_list_controller.g.dart';

@riverpod
class MapSearchResultListNotifier extends _$MapSearchResultListNotifier {
  @override
  Future<List<MapDetail>> build() async {
    final textEditingController = ref.read(mapSearchTextNotifierProvider);
    if (textEditingController.text.isEmpty) {
      return [];
    }
    final map = await MapRepository().getMapDetailMapFromFirebase();
    final mapDetailMap = MapDetailMap(map);
    return mapDetailMap.searchAll(textEditingController.text);
  }

  Future<void> search() async {
    state = await AsyncValue.guard(build);
  }
}
