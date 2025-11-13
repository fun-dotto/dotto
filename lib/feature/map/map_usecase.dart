import 'package:dotto/api/firebase/room_api.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/translator/room_translator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapUseCase {
  MapUseCase({required this.ref});
  final Ref ref;

  Future<List<Room>> getRooms() async {
    final roomsResponse = await ref.read(roomApiProvider).getRooms();
    final roomSchedulesResponse = await ref
        .read(roomApiProvider)
        .getRoomSchedules();
    return RoomTranslator.translate(roomsResponse, roomSchedulesResponse);
  }
}
