import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/feature/map/repository/map_repository.dart';
import 'package:dotto/importer.dart';

final StateProvider<TransformationController>
mapViewTransformationControllerProvider = StateProvider(
  (ref) => TransformationController(Matrix4.identity()),
);
final FutureProvider<MapDetailMap> mapDetailMapProvider = FutureProvider((
  ref,
) async {
  return MapDetailMap(await MapRepository().getMapDetailMapFromFirebase());
});
