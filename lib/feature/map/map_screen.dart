import 'package:dotto/feature/map/widget/map.dart';
import 'package:dotto/feature/map/widget/map_date_picker.dart';
import 'package:dotto/feature/map/widget/map_floor_button.dart';
import 'package:dotto/feature/map/widget/map_legend.dart';
import 'package:dotto/feature/map/widget/map_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('マップ', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      body: const Column(
        spacing: 8,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: MapSearchBar(),
          ),
          Stack(
            children: [
              Column(
                spacing: 8,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: MapFloorButton(),
                  ),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Map(),
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: MapLegend(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: MapDatePicker(),
                  ),
                ],
              ),
              MapSearchListView(),
            ],
          ),
        ],
      ),
    );
  }
}
