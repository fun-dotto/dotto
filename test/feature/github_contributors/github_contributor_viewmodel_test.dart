import 'package:dotto/domain/github_profile.dart';
import 'package:dotto/feature/github_contributor/github_contributor_viewmodel.dart';
import 'package:dotto/feature/github_contributor/github_contributor_viewstate.dart';
import 'package:dotto/repository/github_contoributor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'github_contributor_viewmodel_test.mocks.dart';

abstract interface class Listener<T> {
  void call(T? previous, T next);
}

@GenerateMocks([GitHubContributorRepository, Listener])
void main() {
  final githubContributorRepository = MockGitHubContributorRepository();
  final listener = MockListener<AsyncValue<GitHubContributorViewState>>();

  final testGitHubContributors = [
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
    reset(listener);
    reset(githubContributorRepository);
  });

  group('GitHubContributorViewModel 正常系', () {
    setUp(() {
      when(githubContributorRepository.getContributors()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 1));
        return testGitHubContributors;
      });
    });

    test('初期状態が正しく設定される', () async {
      final container = createContainer()
        ..listen(
          githubContributorViewModelProvider,
          listener.call,
          fireImmediately: true,
        );

      await expectLater(
        container.read(githubContributorViewModelProvider.notifier).future,
        completion(
          isA<GitHubContributorViewState>().having(
            (p0) => p0.contributors,
            'contributors',
            testGitHubContributors,
          ),
        ),
      );
    });

    test('GitHubProfileが正しく取得される', () async {
      final container = createContainer()
        ..listen(
          githubContributorViewModelProvider,
          listener.call,
          fireImmediately: true,
        );

      // 初期状態を待つ
      final initialState = await container
          .read(githubContributorViewModelProvider.notifier)
          .future;

      expect(initialState.contributors, testGitHubContributors);
      expect(initialState.contributors.length, 2);
      expect(initialState.contributors[0].id, '1');
      expect(initialState.contributors[0].login, 'GitHubUser1');
      expect(initialState.contributors[1].id, '2');
      expect(initialState.contributors[1].login, 'GitHubUser2');

      // listener が呼ばれたことを確認
      verify(listener.call(any, any)).called(greaterThan(0));
    });

    test('GitHubProfileが空の場合でも正しく動作する', () async {
      when(githubContributorRepository.getContributors()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 1));
        return <GitHubProfile>[];
      });

      final container = createContainer()
        ..listen(
          githubContributorViewModelProvider,
          listener.call,
          fireImmediately: true,
        );

      // 初期状態を待つ
      final initialState = await container
          .read(githubContributorViewModelProvider.notifier)
          .future;

      expect(initialState.contributors, isEmpty);

      // listener が呼ばれたことを確認
      verify(listener.call(any, any)).called(greaterThan(0));
    });
  });

  group('GitHubContributorViewModel 異常系', () {
    setUp(() {
      when(githubContributorRepository.getContributors()).thenAnswer((_) async {
        throw Exception('Failed to get contributors');
      });
    });

    test('GitHubProfileの取得に失敗した場合にエラーがthrowされる', () async {
      final container = createContainer()
        ..listen(
          githubContributorViewModelProvider,
          listener.call,
          fireImmediately: true,
        );

      // AsyncValue がエラー状態になるまで待つ
      var asyncValue = container.read(githubContributorViewModelProvider);
      var attempts = 0;
      while (!asyncValue.hasError && attempts < 100) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        asyncValue = container.read(githubContributorViewModelProvider);
        attempts++;
      }

      // AsyncValue が AsyncError であることを確認
      expect(asyncValue.hasError, isTrue);
      expect(asyncValue.error, isA<Exception>());
      expect(() => asyncValue.requireValue, throwsA(isA<Exception>()));
    });
  });
}
