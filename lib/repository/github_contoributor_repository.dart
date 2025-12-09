import 'package:dotto/domain/github_profile.dart';

abstract class GitHubContributorRepository {
  Future<List<GitHubProfile>> getContributors();
}
