import 'package:dotto/domain/github_profile.dart';
import 'package:dotto/repository/github_contoributor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class GitHubContributorService {
  GitHubContributorService(this.ref);

  final Ref ref;

  Future<List<GitHubProfile>> getContributors() async {
    return ref.read(githubContributionRepositoryProvider).getContributors();
  }
}
