import 'package:dotto/domain/map_tile_type.dart';
import 'package:dotto/feature/map/controller/using_map_controller.dart';
import 'package:dotto/feature/map/map_view_model.dart';
import 'package:dotto/feature/map/widget/map_detail_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract final class MapColors {
  static Color get using => Colors.orange.shade300;
  static Color get wcMan => Colors.blue.shade800;
  static Color get wcWoman => Colors.red.shade800;
}

// 階段の時の描画設定
final class MapStairType {
  const MapStairType(this.direction, {required this.up, required this.down});
  final Axis direction;
  final bool up;
  final bool down;
  Axis getDirection() {
    return direction;
  }
}

/// require width, height: Size, require ttype: タイルタイプ enum
///
/// top, right, bottom, left: Borderサイズ, txt
// ignore: must_be_immutable
final class MapTile extends StatelessWidget {
  MapTile(
    this.width,
    this.height,
    this.ttype, {
    super.key,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
    this.txt = '',
    this.classroomNo,
    this.lessonIds,
    this.wc = 0x0000,
    this.using = false,
    this.fontSize = 4,
    this.stairType = const MapStairType(Axis.horizontal, up: true, down: true),
    this.useEndTime,
    this.innerWidget,
    this.food,
    this.drink,
    this.outlet,
  }) {
    setColors();
    if (width == 1) {
      fontSize = 3;
    }
    if (txt.length <= 6 && width >= 6) {
      if (txt.length <= 4) {
        fontSize = 8;
      } else {
        fontSize = 6;
      }
    }
  }
  final int width;
  final int height;
  final MapTileType ttype;
  final double top;
  final double right;
  final double bottom;
  final double left;
  final String txt;
  final String? classroomNo;
  List<String>? lessonIds;
  final int wc; // 0x Man: 1000, Woman: 0100, WheelChair: 0010, Kettle: 0001
  bool using;
  double fontSize;
  late Color tileColor;
  late Color fontColor;
  final MapStairType stairType;
  DateTime? useEndTime;
  final Widget? innerWidget;
  final bool? food;
  final bool? drink;
  final int? outlet;

  void setColors() {
    tileColor = ttype.backgroundColor;
    fontColor = ttype.textColor;
  }

  bool get isUsing => using;
  set isUsing(bool b) {
    using = b;
  }

  Color get tileBackgroundColor => tileColor;
  set tileBackgroundColor(Color c) {
    tileColor = c;
  }

  Color get textColor => fontColor;
  set textColor(Color c) {
    fontColor = c;
  }

  DateTime? get endTime => useEndTime;
  set endTime(DateTime? dt) {
    useEndTime = dt;
  }

  List<String>? get lessonIdList => lessonIds;
  set lessonIdList(List<String>? lIds) {
    lessonIds = lIds;
  }

  Widget stackTextIcon() {
    double iconSize = 8;
    final iconLength =
        (wc & 0x0001) +
        (wc & 0x0010) ~/ 0x0010 +
        (wc & 0x0100) ~/ 0x0100 +
        (wc & 0x1000) ~/ 0x1000;
    if (width == 1) {
      iconSize = 6;
    } else if (width * height / iconLength <= 2) {
      iconSize = 6;
    }
    if (wc > 0) {
      final icons = <Icon>[];
      if (wc & 0x1000 > 0) {
        icons.add(Icon(Icons.man, color: MapColors.wcMan, size: iconSize));
      }
      if (wc & 0x0100 > 0) {
        icons.add(Icon(Icons.woman, color: MapColors.wcWoman, size: iconSize));
      }
      if (wc & 0x0010 > 0) {
        icons.add(Icon(Icons.accessible, size: iconSize));
      }
      if (wc & 0x0001 > 0) {
        icons.add(Icon(Icons.coffee_outlined, size: iconSize));
      }
      return Wrap(children: icons);
    }
    if (ttype == MapTileType.ev) {
      return const Icon(
        Icons.elevator_outlined,
        size: 12,
        color: Colors.white,
        weight: 100,
      );
    }
    if (ttype == MapTileType.stair) {
      return SizedBox.expand(
        child: Flex(
          direction: stairType.getDirection(),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (stairType.direction == Axis.horizontal)
              for (int i = 0; i < (width * 2.5).toInt(); i++) ...{
                const Expanded(
                  child: VerticalDivider(thickness: 0.3, color: Colors.black),
                ),
              }
            else
              for (int i = 0; i < (height * 2.5).toInt(); i++) ...{
                const Expanded(
                  child: Divider(thickness: 0.3, color: Colors.black),
                ),
              },
          ],
        ),
      );
    }

    // TODO: Remove Consumer
    return Consumer(
      builder: (context, ref, child) {
        final usingMap = ref.watch(usingMapNotifierProvider);
        setColors();
        if (classroomNo != null) {
          if (usingMap.containsKey(classroomNo)) {
            if (usingMap[classroomNo]!) {
              fontColor = Colors.black;
            }
          }
        }
        return Text(
          txt,
          style: TextStyle(color: fontColor, fontSize: fontSize),
        );
      },
    );
  }

  BorderSide oneBorderSide(double n, {required bool focus}) {
    if (focus) {
      return const BorderSide(color: Colors.red);
    } else if (n > 0) {
      return BorderSide(width: n);
    } else {
      return BorderSide.none;
    }
  }

  EdgeInsets edgeInsets({required bool focus}) {
    return EdgeInsets.only(
      top: (top > 0 || focus) ? 0 : 1,
      right: (right > 0 || focus) ? 0 : 1,
      bottom: (bottom > 0 || focus) ? 0 : 1,
      left: (left > 0 || focus) ? 0 : 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final widgetList = <Widget>[
      SizedBox.expand(
        // TODO: Remove Consumer
        child: Consumer(
          builder: (context, ref, child) {
            final viewModel = ref.watch(mapViewModelProvider);
            final usingMap = ref.watch(usingMapNotifierProvider);
            if (classroomNo != null) {
              if (usingMap.containsKey(classroomNo)) {
                if (usingMap[classroomNo]!) {
                  using = true;
                  tileColor = MapColors.using;
                } else {
                  using = false;
                  setColors();
                }
              }
            }
            var focus = false;
            if (viewModel.focusedMapDetail.floor ==
                viewModel.selectedFloor.label) {
              if (viewModel.focusedMapDetail.roomName == txt) {
                focus = true;
              }
            }
            return Container(
              padding: edgeInsets(focus: focus),
              decoration: BoxDecoration(
                border: Border(
                  top: oneBorderSide(top, focus: focus),
                  right: oneBorderSide(right, focus: focus),
                  bottom: oneBorderSide(bottom, focus: focus),
                  left: oneBorderSide(left, focus: focus),
                ),
                color: (ttype == MapTileType.empty)
                    ? tileColor
                    : MapTileType.road.backgroundColor,
              ),
              child: SizedBox.expand(
                child: (innerWidget == null)
                    ? Container(
                        padding: EdgeInsets.zero,
                        color: focus ? Colors.red : tileColor,
                      )
                    : innerWidget,
              ),
            );
          },
        ),
      ),
      stackTextIcon(),
    ];
    if (ttype == MapTileType.stair) {
      if (stairType.up && !stairType.down) {
        widgetList.add(
          SizedBox.expand(
            child: Center(
              child: Icon(
                Icons.arrow_upward_rounded,
                size: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        );
      } else if (!stairType.up && stairType.down) {
        widgetList.add(
          SizedBox.expand(
            child: Center(
              child: Icon(
                Icons.arrow_downward_rounded,
                size: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        );
      } else if (stairType.up && stairType.down) {
        if (stairType.direction == Axis.horizontal) {
          widgetList.add(
            const SizedBox.expand(
              child: Divider(thickness: 0.3, color: Colors.black),
            ),
          );
        } else {
          widgetList.add(
            const SizedBox.expand(
              child: VerticalDivider(thickness: 0.3, color: Colors.black),
            ),
          );
        }
      }
    }

    // TODO: Remove Consumer
    return Consumer(
      builder: (context, ref, child) {
        final viewModel = ref.watch(mapViewModelProvider);
        return GestureDetector(
          onTap: (txt.isNotEmpty && ttype.index <= MapTileType.subroom.index)
              ? () {
                  showBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return MapDetailBottomSheet(
                        floor: viewModel.selectedFloor.label,
                        roomName: txt,
                      );
                    },
                  );
                  viewModel.focusNode.unfocus();
                }
              : null,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: widgetList,
          ),
        );
      },
    );
  }
}
