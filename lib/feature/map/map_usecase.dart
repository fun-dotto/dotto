import 'package:dotto/domain/room.dart';
import 'package:dotto/repository/room_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapUseCase {
  MapUseCase({required this.ref});
  final Ref ref;

  Future<List<Room>> getRooms() async {
    return ref.read(roomRepositoryProvider).getRooms();
  }
}
