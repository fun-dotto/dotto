import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_profile.freezed.dart';
part 'github_profile.g.dart';

@freezed
abstract class GitHubProfile with _$GitHubProfile {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GitHubProfile({
    required String id,
    required String login,
    required String avatarUrl,
    required String htmlUrl,
  }) = _GitHubProfile;

  factory GitHubProfile.fromJson(Map<String, Object?> json) =>
      _$GitHubProfileFromJson(json);
}
