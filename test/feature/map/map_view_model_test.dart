import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/domain/room_equipment.dart';
import 'package:dotto/domain/room_schedule.dart';
import 'package:dotto/feature/map/fun_map.dart';
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
    Room(
      id: '101',
      name: '講義室',
      shortName: '1短0縮1',
      description: '講義室 101',
      floor: Floor.first,
      email: '',
      keywords: ['講キーワード義キーワード室1', '講キーワード義キーワード室2'],
      schedules: [
        RoomSchedule(
          beginDatetime: DateTime(2025, 11, 1, 9, 0),
          endDatetime: DateTime(2025, 11, 1, 10, 30),
          title: '情報学入門',
        ),
      ],
    ),
    const Room(
      id: '201',
      name: '教員室 201 教員氏 教員名',
      shortName: '2短0縮1',
      description: '情報アーキテクチャ学科\n教授',
      floor: Floor.second,
      email: 'faculty',
      keywords: [],
      schedules: [],
    ),
    const Room(
      id: '301',
      name: 'ライブラリ',
      shortName: '3短0縮1',
      description: 'Test Description 301',
      floor: Floor.third,
      email: '',
      keywords: ['ライキーワードブキーワードリ1'],
      schedules: [],
    ),
    const Room(
      id: '601',
      name: 'その他',
      shortName: '6短0縮1',
      description: 'その他の部屋',
      floor: Floor.sixth,
      email: '',
      keywords: [],
      schedules: [],
    ),
  ];

  final testTileProps = [
    ClassroomMapTileProps(
      floor: Floor.first,
      width: 1,
      height: 1,
      top: 0,
      right: 0,
      bottom: 0,
      left: 0,
      equipment: RoomEquipmentStatus(
        food: RoomEquipmentFood(quality: RoomEquipmentQuality.unavailable),
        drink: RoomEquipmentDrink(quality: RoomEquipmentQuality.limited),
        outlet: RoomEquipmentOutlet(quality: RoomEquipmentQuality.available),
      ),
      id: '101',
    ),
    FacultyRoomMapTileProps(
      floor: Floor.second,
      width: 1,
      height: 1,
      top: 0,
      right: 0,
      bottom: 0,
      left: 0,
      id: '201',
    ),
    SubRoomMapTileProps(
      floor: Floor.third,
      width: 1,
      height: 1,
      top: 0,
      right: 0,
      bottom: 0,
      left: 0,
      id: '301',
    ),
    OtherRoomMapTileProps(
      floor: Floor.sixth,
      width: 1,
      height: 1,
      top: 0,
      right: 0,
      bottom: 0,
      left: 0,
      id: '601',
    ),
  ];

  ProviderContainer createContainer() => ProviderContainer(
    overrides: [
      roomRepositoryProvider.overrideWithValue(roomRepository),
      funMapProvider.overrideWithValue(testTileProps),
    ],
  );

  setUp(() {
    reset(listener);
    reset(roomRepository);
  });

  group('MapViewModel 正常系', () {
    setUp(() {
      when(roomRepository.getRooms()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 1));
        return testRooms;
      });
    });

    test('初期状態が正しく設定される', () async {
      final container = createContainer()
        ..listen(mapViewModelProvider, listener.call, fireImmediately: true);

      await expectLater(
        container.read(mapViewModelProvider.notifier).future,
        completion(
          isA<MapViewModelState>()
              .having((p0) => p0.rooms, 'rooms', testRooms)
              .having((p0) => p0.filteredRooms, 'filteredRooms', isEmpty)
              .having(
                (p0) => p0.focusedMapTileProps,
                'focusedMapTileProps',
                isNull,
              )
              .having((p0) => p0.selectedFloor, 'selectedFloor', Floor.third)
              .having((p0) => p0.focusNode, 'focusNode', isA<FocusNode>())
              .having(
                (p0) => p0.textEditingController,
                'textEditingController',
                isA<TextEditingController>(),
              )
              .having(
                (p0) => p0.transformationController,
                'transformationController',
                isA<TransformationController>(),
              ),
        ),
      );
    });

    test('階数ボタンが押されたときに状態が更新される', () async {
      final container = createContainer()
        ..listen(mapViewModelProvider, listener.call, fireImmediately: true);

      // 初期状態を待つ
      final initialState = await container
          .read(mapViewModelProvider.notifier)
          .future;
      expect(initialState.selectedFloor, Floor.third);
      expect(initialState.focusedMapTileProps, isNull);

      // onFloorButtonTapped を呼び出す
      container
          .read(mapViewModelProvider.notifier)
          .onFloorButtonTapped(Floor.first);

      // 状態が更新されたことを確認
      final updatedState = container.read(mapViewModelProvider).requireValue;
      expect(
        updatedState,
        isA<MapViewModelState>()
            .having((p0) => p0.selectedFloor, 'selectedFloor', Floor.first)
            .having(
              (p0) => p0.focusedMapTileProps,
              'focusedMapTileProps',
              isNull,
            )
            .having(
              (p0) => p0.transformationController.value,
              'transformationController.value',
              Matrix4.identity(),
            ),
      );

      // listener が呼ばれたことを確認
      verify(listener.call(any, any)).called(greaterThan(0));
    });

    test('検索テキストが変更されたときに状態が更新される', () async {
      final container = createContainer()
        ..listen(mapViewModelProvider, listener.call, fireImmediately: true);

      // 初期状態を待つ
      final initialState = await container
          .read(mapViewModelProvider.notifier)
          .future;
      expect(initialState.filteredRooms, isEmpty);

      // onSearchTextChanged を呼び出す
      await container
          .read(mapViewModelProvider.notifier)
          .onSearchTextChanged('101');

      // 状態が更新されたことを確認
      final updatedState = container.read(mapViewModelProvider).requireValue;
      expect(
        updatedState,
        isA<MapViewModelState>().having(
          (p0) => p0.filteredRooms,
          'filteredRooms',
          [testRooms[0]],
        ),
      );

      // listener が呼ばれたことを確認
      verify(listener.call(any, any)).called(greaterThan(0));
    });

    test('検索テキストがクリアされたときに状態が更新される', () async {
      final container = createContainer()
        ..listen(mapViewModelProvider, listener.call, fireImmediately: true);

      // 初期状態を待つ
      final initialState = await container
          .read(mapViewModelProvider.notifier)
          .future;
      expect(initialState.filteredRooms, isEmpty);

      // onSearchTextChanged を呼び出す
      await container
          .read(mapViewModelProvider.notifier)
          .onSearchTextChanged('101');
      final stateAfterSearch = container
          .read(mapViewModelProvider)
          .requireValue;
      expect(
        stateAfterSearch,
        isA<MapViewModelState>().having(
          (p0) => p0.filteredRooms,
          'filteredRooms',
          isNotEmpty,
        ),
      );

      // onSearchTextCleared を呼び出す
      container.read(mapViewModelProvider.notifier).onSearchTextCleared();

      // 状態が更新されたことを確認
      final stateAfterClear = container.read(mapViewModelProvider).requireValue;
      expect(
        stateAfterClear,
        isA<MapViewModelState>().having(
          (p0) => p0.filteredRooms,
          'filteredRooms',
          isEmpty,
        ),
      );

      // listener が呼ばれたことを確認
      verify(listener.call(any, any)).called(greaterThan(0));
    });

    test('検索結果行が押されたときに状態が更新される', () async {
      final container = createContainer()
        ..listen(mapViewModelProvider, listener.call, fireImmediately: true);

      // 初期状態を待つ
      final initialState = await container
          .read(mapViewModelProvider.notifier)
          .future;
      expect(initialState.filteredRooms, isEmpty);

      // onSearchResultRowTapped を呼び出す
      container
          .read(mapViewModelProvider.notifier)
          .onSearchResultRowTapped(testRooms[0]);

      // 状態が更新されたことを確認
      final updatedState = container.read(mapViewModelProvider).requireValue;
      expect(
        updatedState,
        isA<MapViewModelState>()
            .having((p0) => p0.focusNode.hasFocus, 'focusNode.hasFocus', false)
            .having(
              (p0) => p0.selectedFloor,
              'selectedFloor',
              testRooms[0].floor,
            )
            .having(
              (p0) => p0.focusedMapTileProps,
              'focusedMapTileProps',
              testTileProps[0],
            ),
      );

      // listener が呼ばれたことを確認
      verify(listener.call(any, any)).called(greaterThan(0));
    });

    test('マップタイルが押されたときに状態が更新される', () async {
      final container = createContainer()
        ..listen(mapViewModelProvider, listener.call, fireImmediately: true);

      // 初期状態を待つ
      final initialState = await container
          .read(mapViewModelProvider.notifier)
          .future;
      expect(initialState.focusedMapTileProps, isNull);

      // onMapTileTapped を呼び出す
      container
          .read(mapViewModelProvider.notifier)
          .onMapTileTapped(testTileProps[0], testRooms[0]);

      // 状態が更新されたことを確認
      final updatedState = container.read(mapViewModelProvider).requireValue;
      expect(
        updatedState,
        isA<MapViewModelState>()
            .having(
              (p0) => p0.focusedMapTileProps,
              'focusedMapTileProps',
              testTileProps[0],
            )
            .having((p0) => p0.focusNode.hasFocus, 'focusNode.hasFocus', false),
      );

      // listener が呼ばれたことを確認
      verify(listener.call(any, any)).called(greaterThan(0));
    });
  });

  group('MapViewModel 異常系', () {
    setUp(() {
      when(roomRepository.getRooms()).thenAnswer((_) async {
        throw Exception('Failed to get rooms');
      });
    });

    test('部屋情報の取得に失敗した場合にエラーがthrowされる', () async {
      final container = createContainer()
        ..listen(mapViewModelProvider, listener.call, fireImmediately: true);

      // AsyncValue がエラー状態になるまで待つ
      var asyncValue = container.read(mapViewModelProvider);
      var attempts = 0;
      while (!asyncValue.hasError && attempts < 100) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        asyncValue = container.read(mapViewModelProvider);
        attempts++;
      }

      // AsyncValue が AsyncError であることを確認
      expect(asyncValue.hasError, isTrue);
      expect(asyncValue.error, isA<Exception>());
      expect(() => asyncValue.requireValue, throwsA(isA<Exception>()));
    });
  });
}
