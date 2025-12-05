import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/domain/room_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Room.isInUse', () {
    Room createRoom({required List<RoomSchedule> schedules}) => Room(
      id: 'test-room',
      name: 'テスト部屋',
      shortName: 'テスト',
      description: 'テスト用の部屋',
      floor: Floor.first,
      email: '',
      keywords: [],
      schedules: schedules,
    );

    group('スケジュールがない場合', () {
      test('falseを返す', () {
        final room = createRoom(schedules: []);
        final dateTime = DateTime(2025, 11, 1, 10, 0);

        expect(room.isInUse(dateTime), isFalse);
      });
    });

    group('スケジュールがある場合', () {
      test('指定時刻がスケジュールの範囲内の場合はtrueを返す', () {
        final room = createRoom(
          schedules: [
            RoomSchedule(
              beginDatetime: DateTime(2025, 11, 1, 9, 0),
              endDatetime: DateTime(2025, 11, 1, 10, 30),
              title: 'テスト講義',
            ),
          ],
        );
        final dateTime = DateTime(2025, 11, 1, 10, 0);

        expect(room.isInUse(dateTime), isTrue);
      });

      test('指定時刻がスケジュールの開始時刻より前の場合はfalseを返す', () {
        final room = createRoom(
          schedules: [
            RoomSchedule(
              beginDatetime: DateTime(2025, 11, 1, 9, 0),
              endDatetime: DateTime(2025, 11, 1, 10, 30),
              title: 'テスト講義',
            ),
          ],
        );
        final dateTime = DateTime(2025, 11, 1, 8, 0);

        expect(room.isInUse(dateTime), isFalse);
      });

      test('指定時刻がスケジュールの終了時刻より後の場合はfalseを返す', () {
        final room = createRoom(
          schedules: [
            RoomSchedule(
              beginDatetime: DateTime(2025, 11, 1, 9, 0),
              endDatetime: DateTime(2025, 11, 1, 10, 30),
              title: 'テスト講義',
            ),
          ],
        );
        final dateTime = DateTime(2025, 11, 1, 11, 0);

        expect(room.isInUse(dateTime), isFalse);
      });

      test('指定時刻がスケジュールの開始時刻と同じ場合はtrueを返す', () {
        final room = createRoom(
          schedules: [
            RoomSchedule(
              beginDatetime: DateTime(2025, 11, 1, 9, 0),
              endDatetime: DateTime(2025, 11, 1, 10, 30),
              title: 'テスト講義',
            ),
          ],
        );
        final dateTime = DateTime(2025, 11, 1, 9, 0);

        expect(room.isInUse(dateTime), isTrue);
      });

      test('指定時刻がスケジュールの終了時刻と同じ場合はtrueを返す', () {
        final room = createRoom(
          schedules: [
            RoomSchedule(
              beginDatetime: DateTime(2025, 11, 1, 9, 0),
              endDatetime: DateTime(2025, 11, 1, 10, 30),
              title: 'テスト講義',
            ),
          ],
        );
        final dateTime = DateTime(2025, 11, 1, 10, 30);

        expect(room.isInUse(dateTime), isTrue);
      });
    });

    group('複数のスケジュールがある場合', () {
      test('いずれかのスケジュールの範囲内であればtrueを返す', () {
        final room = createRoom(
          schedules: [
            RoomSchedule(
              beginDatetime: DateTime(2025, 11, 1, 9, 0),
              endDatetime: DateTime(2025, 11, 1, 10, 30),
              title: '1限目',
            ),
            RoomSchedule(
              beginDatetime: DateTime(2025, 11, 1, 10, 40),
              endDatetime: DateTime(2025, 11, 1, 12, 10),
              title: '2限目',
            ),
          ],
        );

        // 1限目の範囲内
        expect(room.isInUse(DateTime(2025, 11, 1, 10, 0)), isTrue);
        // 2限目の範囲内
        expect(room.isInUse(DateTime(2025, 11, 1, 11, 0)), isTrue);
      });

      test('すべてのスケジュールの範囲外であればfalseを返す', () {
        final room = createRoom(
          schedules: [
            RoomSchedule(
              beginDatetime: DateTime(2025, 11, 1, 9, 0),
              endDatetime: DateTime(2025, 11, 1, 10, 30),
              title: '1限目',
            ),
            RoomSchedule(
              beginDatetime: DateTime(2025, 11, 1, 10, 40),
              endDatetime: DateTime(2025, 11, 1, 12, 10),
              title: '2限目',
            ),
          ],
        );

        // 1限目と2限目の間
        expect(room.isInUse(DateTime(2025, 11, 1, 10, 35)), isFalse);
        // すべてのスケジュールの前
        expect(room.isInUse(DateTime(2025, 11, 1, 8, 0)), isFalse);
        // すべてのスケジュールの後
        expect(room.isInUse(DateTime(2025, 11, 1, 13, 0)), isFalse);
      });
    });
  });
}
