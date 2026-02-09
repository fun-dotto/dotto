import 'package:dotto/domain/github_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_contributor_viewstate.freezed.dart';

@freezed
abstract class GitHubContributorViewState with _$GitHubContributorViewState {
  const factory GitHubContributorViewState({required List<GitHubProfile> contributors}) = _GitHubContributorViewState;
}
