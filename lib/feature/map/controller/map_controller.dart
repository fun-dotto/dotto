import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/feature/map/repository/map_repository.dart';
import 'package:dotto/importer.dart';

final StateProvider<FocusNode> mapSearchBarFocusProvider = StateProvider(
  (ref) => FocusNode(),
);
final StateProvider<MapDetail> mapFocusMapDetailProvider = StateProvider(
  (ref) => MapDetail.none,
);
final StateProvider<TransformationController>
mapViewTransformationControllerProvider = StateProvider(
  (ref) => TransformationController(Matrix4.identity()),
);
final searchDatetimeProvider =
    NotifierProvider<SearchDatetimeNotifier, DateTime>(
      SearchDatetimeNotifier.new,
    );
final FutureProvider<MapDetailMap> mapDetailMapProvider = FutureProvider((
  ref,
) async {
  return MapDetailMap(await MapRepository().getMapDetailMapFromFirebase());
});

final class SearchDatetimeNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  DateTime get datetime => state;

  set datetime(DateTime dt) {
    state = dt;
  }

  void reset() {
    state = DateTime.now();
  }
}
