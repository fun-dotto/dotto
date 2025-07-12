import 'package:dotto/components/color_fun.dart';
import 'package:dotto/feature/funch/controller/funch_all_daily_menu_controller.dart';
import 'package:dotto/feature/funch/controller/funch_date_controller.dart';
import 'package:dotto/feature/funch/controller/funch_menu_type_controller.dart';
import 'package:dotto/feature/funch/domain/funch_menu_category.dart';
import 'package:dotto/feature/funch/domain/funch_daily_menu.dart';
import 'package:dotto/feature/funch/utility/datetime.dart';
import 'package:dotto/feature/funch/widget/funch_menu_card.dart';
import 'package:dotto/importer.dart';
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
              SizedBox(width: 8),
              Text(
                getDateString(date),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          onPressed: () async {
            if (context.mounted) {
              _showModalBottomSheet(context, ref);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // 均等配置
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 均等配置
              children: menuTypeButton(ref),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: content,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuListByCategory(
    FunchDailyMenu funchDailyMenu,
    FunchMenuCategory category,
  ) {
    if (funchDailyMenu.menuItems.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text("情報がみつかりません。"),
      );
    }

    final filteredItems = funchDailyMenu.getMenuByCategory(category);

    if (filteredItems.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text("このカテゴリーのメニューはありません。"),
      );
    }

    return Column(
      children: filteredItems.map((menu) {
        return MenuCard(menu);
      }).toList(),
    );
  }

  Widget makeMenuTypeButton(FunchMenuCategory menuType, WidgetRef ref) {
    final buttonSize = 50.0;
    final funchMenuType = ref.watch(funchMenuCategoryProvider);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            ref.read(funchMenuCategoryProvider.notifier).set(menuType);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: funchMenuType == menuType ? customFunColor : Colors.white,
            shape: const CircleBorder(
              side: BorderSide(
                color: Colors.black,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            minimumSize: Size(buttonSize, buttonSize),
            fixedSize: Size(buttonSize, buttonSize),
            padding: const EdgeInsets.all(0),
          ),
          // アイコンの配置
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                menuType.icon,
                color: funchMenuType == menuType ? Colors.white : customFunColor,
              ),
            ],
          ),
        ),
        Text(
          menuType.title,
          style: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  List<Widget> menuTypeButton(WidgetRef ref) {
    return FunchMenuCategory.values.map((e) => makeMenuTypeButton(e, ref)).toList();
  }

  String getDateString(DateTime date) {
    return '${DateFormat.yMd('ja').format(date)} (${DateFormat.E('ja').format(date)})';
  }

  void _showModalBottomSheet(BuildContext context, WidgetRef ref) async {
    final funchDailyMenuList = ref.watch(funchAllDailyMenuListProvider);

    final content = funchDailyMenuList.when(
      loading: () {
        const List<Widget> content = [];
        return content;
      },
      error: (error, stackTrace) {
        const List<Widget> content = [];
        return content;
      },
      data: (data) {
        return data.keys.map((e) {
          return InkWell(
            onTap: () {
              ref.read(funchDateProvider.notifier).state = DateTimeUtility.parseDateKey(e);
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getDateString(DateTimeUtility.parseDateKey(e)),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();
      },
    );

    if (context.mounted) {
      showModalBottomSheet(
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
