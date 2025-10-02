import 'package:dotto/feature/map/controller/focused_map_detail_controller.dart';
import 'package:dotto/feature/map/controller/map_page_controller.dart';
import 'package:dotto/feature/map/controller/map_view_transformation_controller.dart';
import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/theme/v1/color_fun.dart';

final class MapFloorButton extends ConsumerWidget {
  const MapFloorButton({super.key});

  static const List<String> floorBarString = [
    '1',
    '2',
    '3',
    '4',
    '5',
    'R6',
    'R7',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapPage = ref.watch(mapPageNotifierProvider);
    final mapPageNotifier = ref.watch(mapPageNotifierProvider.notifier);
    final mapViewTransformationNotifier = ref.read(
      mapViewTransformationNotifierProvider.notifier,
    );
    final focusedMapDetailNotifier = ref.read(
      focusedMapDetailNotifierProvider.notifier,
    );
    const floorBarTextStyle = TextStyle(fontSize: 18, color: Colors.black87);
    const floorBarSelectedTextStyle = TextStyle(
      fontSize: 18,
      color: customFunColor,
    );
    // 350以下なら計算
    final floorButtonWidth = (MediaQuery.of(context).size.width - 30 < 350)
        ? MediaQuery.of(context).size.width - 30
        : 350.0;
    const double floorButtonHeight = 50;

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          color: Colors.grey.withValues(alpha: 0.9),
          width: floorButtonWidth,
          height: floorButtonHeight,
          // Providerから階数の変更を検知
          child: Row(
            children: [
              for (int i = 0; i < 7; i++) ...{
                SizedBox(
                  width: floorButtonWidth / 7,
                  height: floorButtonHeight,
                  child: Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: Size(
                          floorButtonWidth / 7,
                          floorButtonHeight,
                        ),
                        backgroundColor: (mapPage == i) ? Colors.black12 : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      // 階数の変更をProviderに渡す
                      onPressed: () {
                        mapViewTransformationNotifier.value =
                            TransformationController(
                              Matrix4(
                                1,
                                0,
                                0,
                                0,
                                0,
                                1,
                                0,
                                0,
                                0,
                                0,
                                1,
                                0,
                                0,
                                0,
                                0,
                                1,
                              ),
                            );
                        mapPageNotifier.value = i;
                        focusedMapDetailNotifier.value = MapDetail.none;
                        FocusScope.of(context).unfocus();
                      },
                      child: Center(
                        child: Text(
                          floorBarString[i],
                          style: (mapPage == i)
                              ? floorBarSelectedTextStyle
                              : floorBarTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
