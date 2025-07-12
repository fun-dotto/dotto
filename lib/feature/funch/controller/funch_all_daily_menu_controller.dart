import 'package:dotto/feature/funch/domain/funch_daily_menu.dart';
import 'package:dotto/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/funch/repository/funch_repository.dart';
import 'package:dotto/feature/funch/utility/datetime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final funchAllDailyMenuListProvider =
    AsyncNotifierProvider<FunchAllDailyMenuNotifier, Map<String, FunchDailyMenu>>(
        () => FunchAllDailyMenuNotifier(FunchRepositoryImpl()));

final class FunchAllDailyMenuNotifier<FunchRepository extends FunchRepositoryInterface>
    extends AsyncNotifier<Map<String, FunchDailyMenu>> {

  FunchAllDailyMenuNotifier(this._funchRepository);
  final FunchRepository _funchRepository;

  @override
  Future<Map<String, FunchDailyMenu>> build() async {
    final allCommonMenu = await _funchRepository.getAllCommonMenu();
    final allOriginalMenu = await _funchRepository.getAllOriginalMenu();

    final from = DateTimeUtility.startOfDay(DateTime.now());
    final to = DateTimeUtility.startOfDay(from.add(const Duration(days: 6)));

    final monthlyMenuFromFirestore =
        await _funchRepository.getMenuFromFirestore(MenuCollection.monthly, from, to);
    final dailyMenuFromFirestore =
        await _funchRepository.getMenuFromFirestore(MenuCollection.daily, from, to);

    final combinedMenus = <String, FunchDailyMenu>{};

    for (final dateString in dailyMenuFromFirestore.keys) {
      final menuItems = <FunchMenu>[];
      final date = DateTimeUtility.parseDateKey(dateString);
      final firstDayOfMonth = DateTimeUtility.firstDateOfMonth(date);
      monthlyMenuFromFirestore[DateTimeUtility.dateKey(firstDayOfMonth)]
          ?.commonMenuIds
          .forEach((id) {
        final menu = allCommonMenu.firstWhere((m) => m.id == id.toString());
        menuItems.add(menu);
      });
      monthlyMenuFromFirestore[DateTimeUtility.dateKey(firstDayOfMonth)]
          ?.originalMenuIds
          .forEach((id) {
        final menu = allOriginalMenu.firstWhere((m) => m.id == id);
        menuItems.add(menu);
      });
      dailyMenuFromFirestore[DateTimeUtility.dateKey(date)]?.commonMenuIds.forEach((id) {
        final menu = allCommonMenu.firstWhere((m) => m.id == id.toString());
        menuItems.add(menu);
      });
      dailyMenuFromFirestore[DateTimeUtility.dateKey(date)]?.originalMenuIds.forEach((id) {
        final menu = allOriginalMenu.firstWhere((m) => m.id == id);
        menuItems.add(menu);
      });
      combinedMenus[DateTimeUtility.dateKey(date)] = FunchDailyMenu(menuItems);
    }

    return combinedMenus;
  }
}
