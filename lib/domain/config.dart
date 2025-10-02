import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';

@freezed
abstract class Config with _$Config {
  const factory Config({
    required bool isDesignV2Enabled,
    required bool isFunchEnabled,
    required bool isValidAppVersion,
    required String userKeySettingUrl,
    required String announcementsUrl,
    required String assignmentSetupUrl,
    required String feedbackFormUrl,
    required String termsOfServiceUrl,
    required String privacyPolicyUrl,
  }) = _Config;

  static const String cloudflareR2Endpoint = String.fromEnvironment(
    'CLOUDFLARE_R2_ENDPOINT',
  );
  static const String cloudflareR2AccessKeyId = String.fromEnvironment(
    'CLOUDFLARE_R2_ACCESS_KEY_ID',
  );
  static const String cloudflareR2SecretAccessKey = String.fromEnvironment(
    'CLOUDFLARE_R2_SECRET_ACCESS_KEY',
  );
  static const String cloudflareR2BucketName = String.fromEnvironment(
    'CLOUDFLARE_R2_BUCKET_NAME',
  );
}
