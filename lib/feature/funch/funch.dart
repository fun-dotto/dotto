import 'package:dotto/feature/funch/controller/'
    'funch_all_daily_menu_controller.dart';
import 'package:dotto/feature/funch/controller/funch_date_controller.dart';
import 'package:dotto/feature/funch/controller/funch_menu_type_controller.dart';
import 'package:dotto/feature/funch/domain/funch_daily_menu.dart';
import 'package:dotto/feature/funch/domain/funch_menu_category.dart';
import 'package:dotto/feature/funch/utility/datetime.dart';
import 'package:dotto/feature/funch/widget/funch_menu_card.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final class FunchScreen extends ConsumerWidget {
  const FunchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyMenuList = ref.watch(funchAllDailyMenuListProvider);
    final date = ref.watch(funchDateProvider);
    final category = ref.watch(funchMenuCategoryProvider);

    final content = dailyMenuList.when(
      loading: () {
        return const SizedBox.shrink();
      },
      error: (error, stackTrace) {
        return const SizedBox.shrink();
      },
      data: (data) {
        final dailyMenu = data[DateTimeUtility.dateKey(date)];
        if (dailyMenu == null) {
          return const SizedBox.shrink();
        }
        return _menuListByCategory(dailyMenu, category);
      },
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.expand_more,
                color: Colors.white,
                size: 30,
              ), // アイコンの配置
              const SizedBox(width: 8),
              Text(
                getDateString(date),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          onPressed: () async {
            if (context.mounted) {
              await _showModalBottomSheet(context, ref);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // 均等配置
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 均等配置
              children: menuTypeButton(ref),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'メニューは変更される可能性があります',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          Expanded(child: SingleChildScrollView(child: content)),
        ],
      ),
    );
  }

  Widget _menuListByCategory(
    FunchDailyMenu funchDailyMenu,
    FunchMenuCategory category,
  ) {
    if (funchDailyMenu.menuItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text('情報がみつかりません。'),
      );
    }

    final filteredItems = funchDailyMenu.getMenuByCategory(category);

    if (filteredItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text('このカテゴリーのメニューはありません。'),
      );
    }

    return Column(
      children: filteredItems.map((menu) {
        return MenuCard(menu);
      }).toList(),
    );
  }

  Widget makeMenuTypeButton(FunchMenuCategory menuType, WidgetRef ref) {
    const buttonSize = 50.0;
    final funchMenuType = ref.watch(funchMenuCategoryProvider);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            ref.read(funchMenuCategoryProvider.notifier).menuCategory =
                menuType;
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: funchMenuType == menuType
                ? SemanticColor.light.accentPrimary
                : Colors.white,
            shape: const CircleBorder(side: BorderSide()),
            minimumSize: const Size(buttonSize, buttonSize),
            fixedSize: const Size(buttonSize, buttonSize),
            padding: EdgeInsets.zero,
          ),
          // アイコンの配置
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                menuType.icon,
                color: funchMenuType == menuType
                    ? Colors.white
                    : SemanticColor.light.accentPrimary,
              ),
            ],
          ),
        ),
        Text(
          menuType.title,
          style: const TextStyle(fontSize: 10, color: Colors.black),
        ),
      ],
    );
  }

  List<Widget> menuTypeButton(WidgetRef ref) {
    return FunchMenuCategory.values
        .map((e) => makeMenuTypeButton(e, ref))
        .toList();
  }

  String getDateString(DateTime date) {
    return '${DateFormat.yMd('ja').format(date)} '
        '(${DateFormat.E('ja').format(date)})';
  }

  Future<void> _showModalBottomSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final funchDailyMenuList = ref.watch(funchAllDailyMenuListProvider);

    final content = funchDailyMenuList.when(
      loading: () {
        const content = <Widget>[];
        return content;
      },
      error: (error, stackTrace) {
        const content = <Widget>[];
        return content;
      },
      data: (data) {
        return data.keys.map((e) {
          return InkWell(
            onTap: () {
              ref.read(funchDateProvider.notifier).value =
                  DateTimeUtility.parseDateKey(e);
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getDateString(DateTimeUtility.parseDateKey(e)),
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        }).toList();
      },
    );

    if (context.mounted) {
      await showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: content,
            ),
          );
        },
      );
    }
  }
}
