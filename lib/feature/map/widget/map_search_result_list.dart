import 'package:dotto/feature/map/domain/map_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapSearchResultList extends StatelessWidget {
  const MapSearchResultList({
    required this.list,
    required this.focusNode,
    required this.onTapped,
    super.key,
  });

  final AsyncValue<List<MapDetail>> list;
  final FocusNode focusNode;
  final void Function(MapDetail) onTapped;

  @override
  Widget build(BuildContext context) {
    return list.when(
      data: (data) {
        // フォーカスがない場合、または検索結果が空の場合は非表示
        if (!focusNode.hasFocus || data.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, _) => const Divider(height: 0),
                  itemBuilder: (context, int index) {
                    final item = data[index];
                    return ListTile(
                      title: Text(item.header),
                      onTap: () {
                        onTapped(item);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stack) {
        return const SizedBox.shrink();
      },
      loading: () {
        return const SizedBox.shrink();
      },
    );
  }
}
