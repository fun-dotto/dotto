import 'package:dotto/domain/github_profile.dart';
import 'package:dotto/feature/github_contributor/github_contributor_service.dart';
import 'package:dotto/repository/github_contoributor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'github_contributor_service_test.mocks.dart';

/// テスト用の GitHubContributorService Provider
final GitHubContributorServiceProvider = Provider<GitHubContributorService>(
  GitHubContributorService.new,
);

@GenerateMocks([GitHubContributorRepository])
void main() {
  final githubContributorRepository = MockGitHubContributorRepository();

  final testGitHubProfiles = [
    GitHubProfile(
      id: '1',
      login: 'GitHubUser1',
      avatarUrl: 'https://avatars.githubusercontent.com/u/1?v=4',
      htmlUrl: 'https://github.com/GitHubUser1',
    ),
    GitHubProfile(
      id: '2',
      login: 'GitHubUser2',
      avatarUrl: 'https://avatars.githubusercontent.com/u/2?v=4',
      htmlUrl: 'https://github.com/GitHubUser2',
    ),
  ];

  ProviderContainer createContainer() => ProviderContainer(
    overrides: [
      githubContributionRepositoryProvider.overrideWithValue(
        githubContributorRepository,
      ),
    ],
  );

  setUp(() {
    reset(githubContributorRepository);
  });

  group('GitHubContributorService 正常系', () {
    test('getContributors がGitHubプロフィール一覧を正しく取得する', () async {
      when(
        githubContributorRepository.getContributors(),
      ).thenAnswer((_) async => testGitHubProfiles);

      final container = createContainer();
      final service = container.read(githubContributionRepositoryProvider);

      final result = await service.getContributors();

      expect(result, testGitHubProfiles);
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].login, 'GitHubUser1');
      expect(result[1].id, '2');
      expect(result[1].login, 'GitHubUser2');

      verify(githubContributorRepository.getContributors()).called(1);
    });

    test('getContributors が空のリストを正しく取得する', () async {
      when(
        githubContributorRepository.getContributors(),
      ).thenAnswer((_) async => <GitHubProfile>[]);

      final container = createContainer();
      final service = container.read(GitHubContributorServiceProvider);

      final result = await service.getContributors();

      expect(result, isEmpty);

      verify(githubContributorRepository.getContributors()).called(1);
    });
  });

  group('GitHubContributorService 異常系', () {
    test('getContributors がリポジトリの例外をそのまま伝播する', () async {
      when(
        githubContributorRepository.getContributors(),
      ).thenThrow(Exception('Failed to get contributors'));

      final container = createContainer();
      final service = container.read(GitHubContributorServiceProvider);

      expect(() => service.getContributors(), throwsA(isA<Exception>()));

      verify(githubContributorRepository.getContributors()).called(1);
    });
  });
}
