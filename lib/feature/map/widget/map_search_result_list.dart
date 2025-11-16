import 'package:dotto/domain/room.dart';
import 'package:flutter/material.dart';

final class MapSearchResultList extends StatelessWidget {
  const MapSearchResultList({
    required this.rooms,
    required this.isFocused,
    required this.onTapped,
    super.key,
  });

  final List<Room> rooms;
  final bool isFocused;
  final void Function(Room) onTapped;

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty || !isFocused) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: ListView.separated(
              itemCount: rooms.length,
              separatorBuilder: (_, _) => const Divider(height: 0),
              itemBuilder: (context, int index) {
                final item = rooms[index];
                return ListTile(
                  title: Text(item.name),
                  onTap: () => onTapped(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
