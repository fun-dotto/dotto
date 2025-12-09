import 'package:dotto/domain/github_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final githubContributionRepositoryProvider =
    Provider<GitHubContributorRepository>(
      (ref) => GitHubContributorRepositoryImpl(ref),
    );

abstract class GitHubContributorRepository {
  Future<List<GitHubProfile>> getContributors();
}
