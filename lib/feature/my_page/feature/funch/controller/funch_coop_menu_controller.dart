import 'package:dotto/feature/my_page/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/my_page/feature/funch/repository/funch_repository.dart';
import 'package:dotto/importer.dart';

final funchAllCoopMenuProvider =
    NotifierProvider<FunchCoopMenuNotifier, List<FunchCoopMenu>?>(() => FunchCoopMenuNotifier());
final funchDaysMenuProvider = Provider(
  (ref) async {
    final funchAllCoopMenu = ref.watch(funchAllCoopMenuProvider);
    return await FunchRepository().getDaysMenu(ref, funchAllCoopMenu);
  },
);
final funchMonthMenuProvider = Provider(
  (ref) async {
    final funchAllCoopMenu = ref.watch(funchAllCoopMenuProvider);
    return await FunchRepository().getMonthMenu(ref, funchAllCoopMenu);
  },
);

class FunchCoopMenuNotifier extends Notifier<List<FunchCoopMenu>?> {
  final FunchRepository _funchRepository = FunchRepository();

  @override
  List<FunchCoopMenu>? build() {
    return null;
  }

  void fetchAllCoopMenu() async {
    final list = await _funchRepository.getAllCoopMenu();
    state = list;
  }

  List<FunchCoopMenu> getMenuByCategory(int category) {
    if (state == null) return [];
    return state!.where((element) => element.category == category).toList();
  }

  FunchCoopMenu? getMenuById(int id) {
    if (state == null) return null;
    return state!.firstWhere((element) => element.itemCode == id);
  }
}
