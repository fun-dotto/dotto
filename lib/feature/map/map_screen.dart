import 'package:dotto/feature/map/widget/map.dart';
import 'package:dotto/feature/map/widget/map_date_picker.dart';
import 'package:dotto/feature/map/widget/map_floor_button.dart';
import 'package:dotto/feature/map/widget/map_legend.dart';
import 'package:dotto/feature/map/widget/map_search_bar.dart';
import 'package:dotto/feature/map/widget/map_search_result_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('マップ'), centerTitle: false),
      body: Column(
        spacing: 8,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: MapSearchBar(),
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  spacing: 8,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: MapFloorButton(),
                      ),
                    ),
                    const Expanded(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Column(children: [Map(), Spacer()]),
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: MapLegend(),
                          ),
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: MapDatePicker(),
                      ),
                    ),
                  ],
                ),
                const MapSearchResultList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
