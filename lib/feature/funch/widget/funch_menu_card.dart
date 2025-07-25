import 'package:dotto/asset.dart';
import 'package:dotto/feature/funch/domain/funch_menu.dart';
import 'package:dotto/feature/funch/widget/funch_price_list.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/theme/v1/app_color.dart';

final class MenuCard extends StatelessWidget {

  const MenuCard(this.menu, {super.key});
  final FunchMenu menu;

  @override
  Widget build(BuildContext context) {
    final energy =
        menu is FunchCommonMenu ? (menu as FunchCommonMenu).energy : null;
    const double borderRadius = 10;
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                child: menu.imageUrl.isNotEmpty
                    ? Image.network(
                        fit: BoxFit.fill,
                        width: double.infinity,
                        menu.imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            Asset.noImage,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          );
                        },
                      )
                    : Image.asset(
                        Asset.noImage,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 24),
                  ),
                  if (energy != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${energy}kcal'),
                      ],
                    ),
                  const Divider(
                    height: 6,
                    color: AppColor.dividerGrey,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FunchPriceList(menu),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
