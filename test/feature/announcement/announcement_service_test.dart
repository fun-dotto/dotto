import 'package:dotto/domain/announcement.dart';
import 'package:dotto/feature/announcement/announcement_service.dart';
import 'package:dotto/repository/announcement_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'announcement_service_test.mocks.dart';

/// テスト用の AnnouncementService Provider
final announcementServiceProvider = Provider<AnnouncementService>(
  AnnouncementService.new,
);

@GenerateMocks([AnnouncementRepository])
void main() {
  final announcementRepository = MockAnnouncementRepository();

  final testAnnouncements = [
    Announcement(
      id: '1',
      title: 'お知らせ1',
      date: DateTime(2025, 1, 1),
      url: 'https://example.com/announcement1',
    ),
    Announcement(
      id: '2',
      title: 'お知らせ2',
      date: DateTime(2025, 1, 2),
      url: 'https://example.com/announcement2',
    ),
  ];

  ProviderContainer createContainer() => ProviderContainer(
    overrides: [
      announcementRepositoryProvider.overrideWithValue(announcementRepository),
    ],
  );

  setUp(() {
    reset(announcementRepository);
  });

  group('AnnouncementService 正常系', () {
    test('getAnnouncements がお知らせ一覧を正しく取得する', () async {
      when(
        announcementRepository.getAnnouncements(),
      ).thenAnswer((_) async => testAnnouncements);

      final container = createContainer();
      final service = container.read(announcementServiceProvider);

      final result = await service.getAnnouncements();

      expect(result, testAnnouncements);
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].title, 'お知らせ1');
      expect(result[1].id, '2');
      expect(result[1].title, 'お知らせ2');

      verify(announcementRepository.getAnnouncements()).called(1);
    });

    test('getAnnouncements が空のリストを正しく取得する', () async {
      when(
        announcementRepository.getAnnouncements(),
      ).thenAnswer((_) async => <Announcement>[]);

      final container = createContainer();
      final service = container.read(announcementServiceProvider);

      final result = await service.getAnnouncements();

      expect(result, isEmpty);

      verify(announcementRepository.getAnnouncements()).called(1);
    });
  });

  group('AnnouncementService 異常系', () {
    test('getAnnouncements がリポジトリの例外をそのまま伝播する', () async {
      when(
        announcementRepository.getAnnouncements(),
      ).thenThrow(Exception('Failed to get announcements'));

      final container = createContainer();
      final service = container.read(announcementServiceProvider);

      expect(() => service.getAnnouncements(), throwsA(isA<Exception>()));

      verify(announcementRepository.getAnnouncements()).called(1);
    });
  });
}
