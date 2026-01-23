import 'package:dotto/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/funch/domain/funch_menu_category.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class FunchPriceList extends StatelessWidget {
  const FunchPriceList(this.menu, {super.key, this.isHome = false});
  final FunchMenu menu;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: priceText(context),
    );
  }

  List<Widget> priceText(BuildContext context) {
    final priceText = <Widget>[];
    if (![
      ...FunchMenuCategory.donCurry.categoryIds,
      ...FunchMenuCategory.noodle.categoryIds,
    ].contains(menu.categoryId)) {
      return [
        Text(
          '¥${menu.prices.medium}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ];
    }
    final sizeStr = ['大', '中', '小'];
    final price = [menu.prices.large, menu.prices.medium, menu.prices.small];

    for (var i = 0; i < price.length; i++) {
      final p = price[i];
      if (p == null) {
        continue;
      }
      if ((p.isNaN) || p <= 0) {
        continue;
      }
      if (priceText.isNotEmpty) {
        priceText.add(const SizedBox(width: 10));
      }
      priceText.add(
        Wrap(
          children: [
            ClipOval(
              child: Container(
                width: isHome ? 14 : 18,
                height: isHome ? 14 : 18,
                color: SemanticColor.accentMaterialColor.shade400,
                child: Center(
                  child: Text(
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: SemanticColor.light.labelTertiary,
                    ),
                    sizeStr[i],
                  ),
                ),
              ),
            ),
            Text('¥$p', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      );
    }
    return priceText;
  }
}
