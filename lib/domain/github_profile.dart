import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_profile.freezed.dart';

@freezed
abstract class GitHubProfile with _$GitHubProfile {
  const factory GitHubProfile({
    required String id,
    required String login,
    required String avatarUrl,
    required String htmlUrl,
  }) = _GitHubProfile;
}
