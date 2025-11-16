import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/domain/room_equipment.dart';
import 'package:dotto/domain/room_schedule.dart';
import 'package:dotto/feature/map/map_view_model.dart';
import 'package:dotto/feature/map/map_view_model_state.dart';
import 'package:dotto/repository/room_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'map_view_model_test.mocks.dart';

abstract interface class Listener<T> {
  void call(T? previous, T next);
}

@GenerateMocks([RoomRepository, Listener])
void main() {
  final roomRepository = MockRoomRepository();
  final listener = MockListener<AsyncValue<MapViewModelState>>();

  final testRooms = [
    const Room(
      id: '101',
      name: 'Test Room 101',
      shortName: '101',
      description: 'Test Description 101',
      floor: Floor.first,
      email: 'test101@example.com',
      keywords: ['test', 'room'],
      schedules: [],
    ),
    const Room(
      id: '201',
      name: 'Test Room 201',
      shortName: '201',
      description: 'Test Description 201',
      floor: Floor.second,
      email: 'test201@example.com',
      keywords: ['test', 'room', 'second'],
      schedules: [],
    ),
    Room(
      id: '301',
      name: 'Test Room 301',
      shortName: '301',
      description: 'Test Description 301',
      floor: Floor.third,
      email: 'test301@example.com',
      keywords: ['test', 'room', 'third'],
      schedules: [
        RoomSchedule(
          beginDatetime: DateTime(2024, 1, 1, 10, 0),
          endDatetime: DateTime(2024, 1, 1, 12, 0),
          title: 'Test Schedule',
        ),
      ],
    ),
  ];

  final testEquipment = RoomEquipmentStatus(
    food: RoomEquipmentFood(quality: RoomEquipmentQuality.available),
    drink: RoomEquipmentDrink(quality: RoomEquipmentQuality.available),
    outlet: RoomEquipmentOutlet(quality: RoomEquipmentQuality.available),
  );

  ProviderContainer createContainer() => ProviderContainer(
    overrides: [roomRepositoryProvider.overrideWithValue(roomRepository)],
  );

  group('MapViewModel', () {
    setUp(() {
      reset(roomRepository);
      reset(listener);
    });

    test('初期状態が正しく設定される', () async {
      when(roomRepository.getRooms()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 1));
        return testRooms;
      });

      final container = createContainer()
        ..listen(mapViewModelProvider, listener.call, fireImmediately: true);

      await expectLater(
        container.read(mapViewModelProvider.future),
        completion(
          isA<MapViewModelState>()
              .having((p0) => p0.rooms, "rooms", testRooms)
              .having((p0) => p0.filteredRooms, "filteredRooms", isEmpty)
              .having((p0) => p0.focusedRoom, "focusedRoom", isNull)
              .having((p0) => p0.selectedFloor, "selectedFloor", Floor.third)
              .having((p0) => p0.focusNode, "focusNode", isA<FocusNode>())
              .having(
                (p0) => p0.textEditingController,
                "textEditingController",
                isA<TextEditingController>(),
              )
              .having(
                (p0) => p0.transformationController,
                "transformationController",
                isA<TransformationController>(),
              ),
        ),
      );
    });
  });
}
