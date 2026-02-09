import 'package:dotto/domain/announcement.dart';
import 'package:dotto/feature/announcement/announcement_viewmodel.dart';
import 'package:dotto/feature/announcement/announcement_viewstate.dart';
import 'package:dotto/repository/announcement_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'announcement_viewmodel_test.mocks.dart';

abstract interface class Listener<T> {
  void call(T? previous, T next);
}

@GenerateMocks([AnnouncementRepository, Listener])
void main() {
  final announcementRepository = MockAnnouncementRepository();
  final listener = MockListener<AsyncValue<AnnouncementViewState>>();

  final testAnnouncements = [
    Announcement(id: '1', title: 'お知らせ1', date: DateTime(2025, 1, 1), url: 'https://example.com/announcement1'),
    Announcement(id: '2', title: 'お知らせ2', date: DateTime(2025, 1, 2), url: 'https://example.com/announcement2'),
  ];

  ProviderContainer createContainer() =>
      ProviderContainer(overrides: [announcementRepositoryProvider.overrideWithValue(announcementRepository)]);

  setUp(() {
    reset(listener);
    reset(announcementRepository);
  });

  group('AnnouncementViewModel 正常系', () {
    setUp(() {
      when(announcementRepository.getAnnouncements()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 1));
        return testAnnouncements;
      });
    });

    test('初期状態が正しく設定される', () async {
      final container = createContainer()..listen(announcementViewModelProvider, listener.call, fireImmediately: true);

      await expectLater(
        container.read(announcementViewModelProvider.notifier).future,
        completion(isA<AnnouncementViewState>().having((p0) => p0.announcements, 'announcements', testAnnouncements)),
      );
    });

    test('お知らせが正しく取得される', () async {
      final container = createContainer()..listen(announcementViewModelProvider, listener.call, fireImmediately: true);

      // 初期状態を待つ
      final initialState = await container.read(announcementViewModelProvider.notifier).future;

      expect(initialState.announcements, testAnnouncements);
      expect(initialState.announcements.length, 2);
      expect(initialState.announcements[0].id, '1');
      expect(initialState.announcements[0].title, 'お知らせ1');
      expect(initialState.announcements[1].id, '2');
      expect(initialState.announcements[1].title, 'お知らせ2');

      // listener が呼ばれたことを確認
      verify(listener.call(any, any)).called(greaterThan(0));
    });

    test('お知らせが空の場合でも正しく動作する', () async {
      when(announcementRepository.getAnnouncements()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 1));
        return <Announcement>[];
      });

      final container = createContainer()..listen(announcementViewModelProvider, listener.call, fireImmediately: true);

      // 初期状態を待つ
      final initialState = await container.read(announcementViewModelProvider.notifier).future;

      expect(initialState.announcements, isEmpty);

      // listener が呼ばれたことを確認
      verify(listener.call(any, any)).called(greaterThan(0));
    });
  });

  group('AnnouncementViewModel 異常系', () {
    setUp(() {
      when(announcementRepository.getAnnouncements()).thenAnswer((_) async {
        throw Exception('Failed to get announcements');
      });
    });

    test('お知らせの取得に失敗した場合にエラーがthrowされる', () async {
      final container = createContainer()..listen(announcementViewModelProvider, listener.call, fireImmediately: true);

      // AsyncValue がエラー状態になるまで待つ
      var asyncValue = container.read(announcementViewModelProvider);
      var attempts = 0;
      while (!asyncValue.hasError && attempts < 100) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        asyncValue = container.read(announcementViewModelProvider);
        attempts++;
      }

      // AsyncValue が AsyncError であることを確認
      expect(asyncValue.hasError, isTrue);
      expect(asyncValue.error, isA<Exception>());
      expect(() => asyncValue.requireValue, throwsA(isA<Exception>()));
    });
  });
}
