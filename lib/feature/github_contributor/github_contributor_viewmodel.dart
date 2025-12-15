import 'package:dotto/feature/github_contributor/github_contributor_service.dart';
import 'package:dotto/feature/github_contributor/github_contributor_viewstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'github_contributor_viewmodel.g.dart';

@riverpod
final class GithubContributorViewmodel extends _$GithubContributorViewmodel {
  @override
  Future<GitHubContributorViewState> build() async {
    final service = GitHubContributorService(ref);
    final contributors = await service.getContributors();
    return GitHubContributorViewState(contributors: contributors);
  }

  Future<void> onRefresh() async {
    state = await AsyncValue.guard(() async {
      final service = GitHubContributorService(ref);
      final contributors = await service.getContributors();
      return GitHubContributorViewState(contributors: contributors);
    });
  }
}
