import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/domain/room_equipment.dart';
import 'package:dotto/domain/room_schedule.dart';
import 'package:dotto/feature/map/map_view_model.dart';
import 'package:dotto/repository/room_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'map_view_model_test.mocks.dart';

@GenerateMocks([RoomRepository])
void main() {
  late ProviderContainer container;
  late MockRoomRepository mockRoomRepository;

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

  setUp(() {
    mockRoomRepository = MockRoomRepository();
    when(mockRoomRepository.getRooms()).thenAnswer((_) async {
      // 少し遅延を入れて、非同期処理をシミュレート
      await Future<void>.delayed(const Duration(milliseconds: 1));
      return testRooms;
    });
    container = ProviderContainer(
      overrides: [roomRepositoryProvider.overrideWithValue(mockRoomRepository)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  // 部屋リストが読み込まれるまで待つヘルパー関数
  Future<void> waitForRooms() async {
    // プロバイダーを読み込んで初期化をトリガー
    container.read(mapViewModelProvider);

    // _getRooms は非同期で実行されるため、部屋リストが読み込まれるまで待つ
    // 最大100回（1秒）まで待つ
    final maxAttempts = 100;
    var attempts = 0;
    while (container.read(mapViewModelProvider).rooms.isEmpty &&
        attempts < maxAttempts) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      attempts++;
    }
    if (attempts >= maxAttempts) {
      // モックが呼ばれたか確認
      try {
        verify(mockRoomRepository.getRooms()).called(greaterThanOrEqualTo(1));
      } catch (e) {
        throw Exception('getRooms was not called. Rooms may not be loading.');
      }
      throw Exception('Timeout waiting for rooms to load');
    }
  }

  group('MapViewModel', () {
    test('初期状態が正しく設定される', () async {
      final state = container.read(mapViewModelProvider);

      expect(state.rooms, isEmpty);
      expect(state.filteredRooms, isEmpty);
      expect(state.focusedRoom, isNull);
      expect(state.selectedFloor, Floor.third);
      expect(state.focusNode, isA<FocusNode>());
      expect(state.textEditingController, isA<TextEditingController>());
      expect(state.transformationController, isA<TransformationController>());

      // _getRooms が非同期で実行されるため、部屋リストが読み込まれるまで待つ
      await waitForRooms();

      final updatedState = container.read(mapViewModelProvider);
      expect(updatedState.rooms, testRooms);
      verify(mockRoomRepository.getRooms()).called(1);
    });

    test('onFloorButtonTapped でフロアが変更される', () {
      container.read(mapViewModelProvider.notifier)
        // 初期状態で focusedRoom を設定
        ..onMapTileTapped(
          ClassroomMapTileProps(
            floor: Floor.third,
            width: 1,
            height: 1,
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            equipment: testEquipment,
          ),
          testRooms[2],
        )
        // フロアを変更
        ..onFloorButtonTapped(Floor.first);

      final updatedState = container.read(mapViewModelProvider);
      expect(updatedState.selectedFloor, Floor.first);
      expect(updatedState.focusedRoom, isNull);
      expect(updatedState.transformationController.value, Matrix4.identity());
    });

    test('onSearchResultRowTapped で部屋がフォーカスされる', () {
      final viewModel = container.read(mapViewModelProvider.notifier);
      final room = testRooms[0];

      viewModel.onSearchResultRowTapped(room);

      final state = container.read(mapViewModelProvider);
      expect(state.selectedFloor, room.floor);
      expect(state.focusedRoom, room);
      expect(state.transformationController.value, Matrix4.identity());
    });

    test('onSearchTextChanged で検索結果が更新される', () async {
      final viewModel = container.read(mapViewModelProvider.notifier);

      // 部屋リストを設定
      await waitForRooms();
      final stateWithRooms = container.read(mapViewModelProvider);
      expect(stateWithRooms.rooms, testRooms);

      // 検索テキストを設定
      stateWithRooms.textEditingController.text = '101';
      await viewModel.onSearchTextChanged('101');

      final updatedState = container.read(mapViewModelProvider);
      expect(updatedState.filteredRooms.length, 1);
      expect(updatedState.filteredRooms[0].id, '101');
    });

    test('onSearchTextChanged で空の検索テキストの場合、空のリストが返される', () async {
      final viewModel = container.read(mapViewModelProvider.notifier);

      await waitForRooms();
      final stateWithRooms = container.read(mapViewModelProvider);
      stateWithRooms.textEditingController.text = '';

      await viewModel.onSearchTextChanged('');

      final updatedState = container.read(mapViewModelProvider);
      expect(updatedState.filteredRooms, isEmpty);
    });

    test('onSearchTextChanged で複数の検索条件にマッチする部屋が返される', () async {
      final viewModel = container.read(mapViewModelProvider.notifier);

      await waitForRooms();
      final stateWithRooms = container.read(mapViewModelProvider);
      stateWithRooms.textEditingController.text = 'test';

      await viewModel.onSearchTextChanged('test');

      final updatedState = container.read(mapViewModelProvider);
      expect(updatedState.filteredRooms.length, 3);
    });

    test('onSearchTextChanged でキーワードで検索できる', () async {
      final viewModel = container.read(mapViewModelProvider.notifier);

      await waitForRooms();
      final stateWithRooms = container.read(mapViewModelProvider);
      stateWithRooms.textEditingController.text = 'second';

      await viewModel.onSearchTextChanged('second');

      final updatedState = container.read(mapViewModelProvider);
      expect(updatedState.filteredRooms.length, 1);
      expect(updatedState.filteredRooms[0].id, '201');
    });

    test('onSearchTextChanged で大文字小文字を区別しない', () async {
      final viewModel = container.read(mapViewModelProvider.notifier);

      await waitForRooms();
      final stateWithRooms = container.read(mapViewModelProvider);
      stateWithRooms.textEditingController.text = 'TEST';

      await viewModel.onSearchTextChanged('TEST');

      final updatedState = container.read(mapViewModelProvider);
      expect(updatedState.filteredRooms.length, 3);
    });

    test('onSearchTextSubmitted で検索結果が更新される', () async {
      final viewModel = container.read(mapViewModelProvider.notifier);

      await waitForRooms();
      final stateWithRooms = container.read(mapViewModelProvider);
      stateWithRooms.textEditingController.text = '201';

      await viewModel.onSearchTextSubmitted('201');

      final updatedState = container.read(mapViewModelProvider);
      expect(updatedState.filteredRooms.length, 1);
      expect(updatedState.filteredRooms[0].id, '201');
    });

    test('onSearchTextCleared で検索結果がクリアされる', () async {
      final viewModel = container.read(mapViewModelProvider.notifier);

      await waitForRooms();
      final stateWithRooms = container.read(mapViewModelProvider);
      stateWithRooms.textEditingController.text = '101';
      await viewModel.onSearchTextChanged('101');

      // 検索結果が設定されていることを確認
      final stateWithFilter = container.read(mapViewModelProvider);
      expect(stateWithFilter.filteredRooms.isNotEmpty, true);

      // クリア
      stateWithFilter.textEditingController.text = '';
      await viewModel.onSearchTextCleared();

      final updatedState = container.read(mapViewModelProvider);
      expect(updatedState.filteredRooms, isEmpty);
    });

    test('onPeriodButtonTapped で検索日時が更新される', () {
      final viewModel = container.read(mapViewModelProvider.notifier);
      final newDateTime = DateTime(2024, 1, 1, 15, 0);

      viewModel.onPeriodButtonTapped(newDateTime);

      final state = container.read(mapViewModelProvider);
      expect(state.searchDatetime, newDateTime);
    });

    test('onDatePickerConfirmed で検索日時が更新される', () {
      final viewModel = container.read(mapViewModelProvider.notifier);
      final newDateTime = DateTime(2024, 1, 2, 10, 0);

      viewModel.onDatePickerConfirmed(newDateTime);

      final state = container.read(mapViewModelProvider);
      expect(state.searchDatetime, newDateTime);
    });

    test('onMapTileTapped で部屋がフォーカスされる', () {
      final viewModel = container.read(mapViewModelProvider.notifier);
      final room = testRooms[1];
      final props = ClassroomMapTileProps(
        floor: Floor.second,
        width: 1,
        height: 1,
        top: 0,
        right: 0,
        bottom: 0,
        left: 0,
        equipment: testEquipment,
      );

      viewModel.onMapTileTapped(props, room);

      final state = container.read(mapViewModelProvider);
      expect(state.focusedRoom, room);
    });

    test('onMapTileTapped で room が null の場合、focusedRoom が null になる', () {
      final viewModel = container.read(mapViewModelProvider.notifier);
      final props = AisleMapTileProps(
        floor: Floor.second,
        width: 1,
        height: 1,
        top: 0,
        right: 0,
        bottom: 0,
        left: 0,
      );

      viewModel.onMapTileTapped(props, null);

      final state = container.read(mapViewModelProvider);
      expect(state.focusedRoom, isNull);
    });

    test('検索で id, name, description, email のいずれかにマッチする', () async {
      final viewModel = container.read(mapViewModelProvider.notifier);

      await waitForRooms();
      final stateWithRooms = container.read(mapViewModelProvider);

      // id で検索
      stateWithRooms.textEditingController.text = '101';
      await viewModel.onSearchTextChanged('101');
      expect(container.read(mapViewModelProvider).filteredRooms.length, 1);

      // name で検索
      stateWithRooms.textEditingController.text = 'Room 201';
      await viewModel.onSearchTextChanged('Room 201');
      expect(container.read(mapViewModelProvider).filteredRooms.length, 1);

      // description で検索
      stateWithRooms.textEditingController.text = 'Description 301';
      await viewModel.onSearchTextChanged('Description 301');
      expect(container.read(mapViewModelProvider).filteredRooms.length, 1);

      // email で検索
      stateWithRooms.textEditingController.text = 'test201@example.com';
      await viewModel.onSearchTextChanged('test201@example.com');
      expect(container.read(mapViewModelProvider).filteredRooms.length, 1);
    });
  });
}
