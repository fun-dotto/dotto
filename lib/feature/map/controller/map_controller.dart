import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/feature/map/repository/map_repository.dart';
import 'package:dotto/importer.dart';

final FutureProvider<MapDetailMap> mapDetailMapProvider = FutureProvider((
  ref,
) async {
  return MapDetailMap(await MapRepository().getMapDetailMapFromFirebase());
});
