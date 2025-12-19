import 'package:dotto/domain/github_profile.dart';
import 'package:dotto/feature/github_contributor/github_contributor_viewmodel.dart';
import 'package:dotto/feature/github_contributor/github_contributor_viewstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class GitHubContributorScreen extends ConsumerWidget {
  const GitHubContributorScreen({super.key});

  Widget _githubContributorListRow(GitHubProfile githubProfile) {
    return ListTile(
      leading: GestureDetector(
        onTap: () => launchUrlString(githubProfile.htmlUrl),
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(githubProfile.avatarUrl),
          backgroundColor: Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _body(
    AsyncValue<GitHubContributorViewState> viewModelAsync, {
    required Future<void> Function() onRefresh,
  }) {
    switch (viewModelAsync) {
      case AsyncData(:final value):
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            itemCount: value.contributors.length,
            separatorBuilder: (_, _) => const Divider(height: 0),
            itemBuilder: (_, index) {
              final contributor = value.contributors[index];
              return _githubContributorListRow(contributor);
            },
          ),
        );
      case AsyncError(:final error):
        return Center(child: Text('エラーが発生しました: $error'));
      case AsyncLoading():
        return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelAsync = ref.watch(githubContributorViewmodelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('開発者一覧')),
      body: _body(
        viewModelAsync,
        onRefresh: () async {
          await ref
              .read(githubContributorViewmodelProvider.notifier)
              .onRefresh();
        },
      ),
    );
  }
}
