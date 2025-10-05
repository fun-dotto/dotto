import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotto/asset.dart';
import 'package:dotto/feature/funch/controller/funch_mypage_card_index_controller.dart';
import 'package:dotto/feature/funch/controller/funch_today_daily_menu_controller.dart';
import 'package:dotto/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/funch/funch.dart';
import 'package:dotto/feature/funch/utility/datetime.dart';
import 'package:dotto/feature/funch/widget/funch_price_list.dart';
import 'package:dotto/theme/v1/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final class FunchMyPageCard extends ConsumerWidget {
  const FunchMyPageCard({super.key});

  ImageProvider<Object> _getBackgroundImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage(Asset.noImage);
    }
  }

  String _getDayString(DateTime date) {
    final today = DateTime.now();
    if (today.day == date.day) {
      return '今日';
    } else if (today.day + 1 == date.day) {
      return '明日';
    }
    final formatter = DateFormat('MM月dd日');
    return formatter.format(date);
  }

  Widget _buildEmptyCard(BuildContext context, DateTime date) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: Text('情報が見つかりません')),
    );
  }

  Widget _buildCarousel(WidgetRef ref, List<FunchMenu> menu) {
    return CarouselSlider(
      items: menu.map(_buildCarouselItem).toList(),
      options: CarouselOptions(
        aspectRatio: 4 / 3,
        autoPlay: true,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          ref.read(funchMyPageCardIndexProvider.notifier).state = index;
        },
      ),
    );
  }

  Widget _buildCarouselItem(FunchMenu menu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: _getBackgroundImage(menu.imageUrl),
            width: double.infinity,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                Asset.noImage,
                width: double.infinity,
                fit: BoxFit.fill,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(menu.name, style: const TextStyle(fontSize: 18)),
              const Divider(height: 2, color: AppColor.dividerGrey),
              const SizedBox(height: 5),
              FunchPriceList(menu, isHome: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselIndicators(
    BuildContext context,
    WidgetRef ref,
    List<FunchMenu> menuList,
  ) {
    final selectedIndex = ref.watch(funchMyPageCardIndexProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: menuList.map((menu) {
          final index = menuList.indexOf(menu);
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withValues(alpha: selectedIndex == index ? 0.9 : 0.4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, WidgetRef ref) {
    final date = DateTimeUtility.startOfDay(DateTime.now());
    final funchDailyMenuList = ref.watch(funchTodayDailyMenuListProvider);

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text('${_getDayString(date)}の学食'),
            funchDailyMenuList.when(
              data: (data) {
                final menuItems =
                    data[DateTimeUtility.dateKey(date)]?.menuItems;
                if (menuItems == null) {
                  return _buildEmptyCard(context, date);
                }
                if (menuItems.isEmpty) {
                  return _buildEmptyCard(context, date);
                }
                return _buildCarousel(ref, menuItems);
              },
              error: (error, stackTrace) => _buildEmptyCard(context, date),
              loading: () => const SizedBox.shrink(),
            ),
            funchDailyMenuList.when(
              data: (data) {
                final menuItems =
                    data[DateTimeUtility.dateKey(date)]?.menuItems;
                if (menuItems == null) {
                  return const SizedBox.shrink();
                }
                if (menuItems.isEmpty) {
                  return const SizedBox.shrink();
                }
                return _buildCarouselIndicators(context, ref, menuItems);
              },
              error: (error, stackTrace) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (context) => const FunchScreen()),
        );
      },
      child: _buildMenuCard(context, ref),
    );
  }
}
