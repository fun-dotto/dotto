import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotto/components/app_color.dart';
import 'package:dotto/components/widgets/progress_indicator.dart';
import 'package:dotto/feature/funch/controller/funch_providers.dart';
import 'package:dotto/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/funch/funch.dart';
import 'package:dotto/feature/funch/repository/funch_repository.dart';
import 'package:dotto/feature/funch/widget/funch_price_list.dart';
import 'package:dotto/importer.dart';
import 'package:intl/intl.dart';

class MyPageFunchCard extends ConsumerWidget {
  const MyPageFunchCard({super.key});

  Future<List<FunchMenu>> _getDaysMenu(WidgetRef ref, DateTime date) async {
    final funchDaysMenu = await ref.watch(funchDaysMenuProvider);
    return [...funchDaysMenu[date]?.menu ?? [], ...funchDaysMenu[date]?.originalMenu ?? []];
  }

  ImageProvider<Object> _getBackgroundImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return NetworkImage(
        imageUrl,
      );
    } else {
      return const AssetImage('assets/images/no_image.png');
    }
  }

  String _getDayString(DateTime date) {
    final today = DateTime.now();
    if (today.day == date.day) {
      return "今日";
    } else if (today.day + 1 == date.day) {
      return "明日";
    }
    final formatter = DateFormat('MM月dd日');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextDay = FunchRepository().nextDay();
    final dayString = _getDayString(nextDay);
    
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FunchScreen(),
            ),
          ),
          child: FutureBuilder(
            future: _getDaysMenu(ref, nextDay),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: createProgressIndicator());
              }
              final menu = snapshot.data as List<FunchMenu>;
              
              if (menu.isEmpty) {
                return _buildEmptyCard(context, dayString, snapshot);
              }
              
              return _buildMenuCard(context, ref, menu, dayString);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCard(BuildContext context, String dayString, AsyncSnapshot snapshot) {
    return Center(
      child: Card(
        color: AppColor.textWhite,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$dayStringの学食",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              snapshot.connectionState == ConnectionState.waiting
                  ? createProgressIndicator()
                  : Center(
                      child: Text("$dayStringの学食情報はありません"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, WidgetRef ref, List<FunchMenu> menu, String dayString) {
    const borderRadius = 10.0;
    
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.075, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(dayString),
          _buildCarousel(ref, menu),
          _buildIndicators(context, ref, menu),
        ],
      ),
    );
  }

  Widget _buildHeader(String dayString) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        "$dayStringの学食",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildCarousel(WidgetRef ref, List<FunchMenu> menu) {
    return CarouselSlider(
      items: menu.map((e) => _buildCarouselItem(e)).toList(),
      options: CarouselOptions(
        aspectRatio: 4 / 3,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          ref.read(funchMyPageIndexProvider.notifier).state = index;
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
            fit: BoxFit.cover,
            width: double.infinity,
            image: _getBackgroundImage(menu.imageUrl),
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/no_image.png');
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                menu.name,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Divider(
                height: 2,
                color: AppColor.dividerGrey,
              ),
              SizedBox(height: 5),
              FunchPriceList(menu, isHome: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicators(BuildContext context, WidgetRef ref, List<FunchMenu> menu) {
    final mypageIndex = ref.watch(funchMyPageIndexProvider);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < menu.length; i++) ...{
          Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                    .withOpacity(mypageIndex == i ? 0.9 : 0.4)),
          ),
        },
      ],
    );
  }
}
