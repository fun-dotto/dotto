import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/feature/map/repository/map_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'map_detail_map_controller.g.dart';

@riverpod
class MapDetailMapNotifier extends _$MapDetailMapNotifier {
  @override
  Future<MapDetailMap> build() async {
    final map = await MapRepository().getMapDetailMapFromFirebase();
    return MapDetailMap(map);
  }
}
