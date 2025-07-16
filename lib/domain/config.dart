import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';

@freezed
abstract class Config with _$Config {
  const factory Config({
    @Default(false) bool isDesignV2Enabled,
    @Default(false) bool isFunchEnabled,
    @Default(false) bool isValidAppVersion,
    @Default('') String assignmentSetupUrl,
    @Default('') String feedbackFormUrl,
  }) = _Config;

  static const String cloudflareR2Endpoint =
      String.fromEnvironment('CLOUDFLARE_R2_ENDPOINT');
  static const String cloudflareR2AccessKeyId =
      String.fromEnvironment('CLOUDFLARE_R2_ACCESS_KEY_ID');
  static const String cloudflareR2SecretAccessKey =
      String.fromEnvironment('CLOUDFLARE_R2_SECRET_ACCESS_KEY');
  static const String cloudflareR2BucketName =
      String.fromEnvironment('CLOUDFLARE_R2_BUCKET_NAME');
}
