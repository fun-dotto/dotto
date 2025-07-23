import 'package:collection/collection.dart';
import 'package:dotto/feature/funch/domain/funch_daily_menu.dart';
import 'package:dotto/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/funch/repository/funch_repository.dart';
import 'package:dotto/feature/funch/utility/datetime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final funchAllDailyMenuListProvider = AsyncNotifierProvider<
        FunchAllDailyMenuNotifier, Map<String, FunchDailyMenu>>(
    () => FunchAllDailyMenuNotifier(FunchRepositoryImpl()));

final class FunchAllDailyMenuNotifier<
        FunchRepository extends FunchRepositoryInterface>
    extends AsyncNotifier<Map<String, FunchDailyMenu>> {
  FunchAllDailyMenuNotifier(this._funchRepository);
  final FunchRepository _funchRepository;

  @override
  Future<Map<String, FunchDailyMenu>> build() async {
    try {
      final allCommonMenu = await _funchRepository.getAllCommonMenu();
      final allOriginalMenu = await _funchRepository.getAllOriginalMenu();

      final from = DateTimeUtility.startOfDay(DateTime.now());
      final to = DateTimeUtility.startOfDay(from.add(const Duration(days: 6)));

      final monthlyMenuFromFirestore = await _funchRepository
          .getMenuFromFirestore(MenuCollection.monthly, from, to);
      final dailyMenuFromFirestore = await _funchRepository
          .getMenuFromFirestore(MenuCollection.daily, from, to);

      final combinedMenus = <String, FunchDailyMenu>{};

      for (final dateString in dailyMenuFromFirestore.keys) {
        final menuItems = <FunchMenu>[];
        final date = DateTimeUtility.parseDateKey(dateString);
        final firstDayOfMonth = DateTimeUtility.firstDateOfMonth(date);
        final monthlyMenu =
            monthlyMenuFromFirestore[DateTimeUtility.dateKey(firstDayOfMonth)];
        final dailyMenu = dailyMenuFromFirestore[DateTimeUtility.dateKey(date)];

        for (final id in (monthlyMenu?.commonMenuIds ?? [])) {
          final menu =
              allCommonMenu.firstWhereOrNull((m) => m.id == id.toString());
          if (menu != null) {
            menuItems.add(menu);
          }
        }
        for (final id in (monthlyMenu?.originalMenuIds ?? [])) {
          final menu = allOriginalMenu.firstWhereOrNull((m) => m.id == id);
          if (menu != null) {
            menuItems.add(menu);
          }
        }
        for (final id in (dailyMenu?.commonMenuIds ?? [])) {
          final menu =
              allCommonMenu.firstWhereOrNull((m) => m.id == id.toString());
          if (menu != null) {
            menuItems.add(menu);
          }
        }
        for (final id in (dailyMenu?.originalMenuIds ?? [])) {
          final menu = allOriginalMenu.firstWhereOrNull((m) => m.id == id);
          if (menu != null) {
            menuItems.add(menu);
          }
        }
        combinedMenus[DateTimeUtility.dateKey(date)] =
            FunchDailyMenu(menuItems);
      }

      return combinedMenus;
    } catch (e) {
      debugPrint('FunchAllDailyMenuNotifier Error: $e');
      rethrow;
    }
  }
}
