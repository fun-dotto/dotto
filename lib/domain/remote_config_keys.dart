final class RemoteConfigKeys {
  /// 廃止予定: Design System v2 feature flag
  static const String isDesignV2Enabled = 'is_design_v2_enabled';

  /// Funch feature flag
  static const String isFunchEnabled = 'is_funch_enabled';

  /// アプリのバージョンが有効かどうか
  ///
  /// 無効の場合: 強制アップデート対象
  ///
  /// アプリストアへの遷移のみ可能な画面が表示されるようにし、アプリの一切の機能を利用できないようにする
  ///
  /// ただし、オフラインの場合は、バイパスする
  static const String isValidAppVersion = 'is_valid_app_version';

  /// アプリのバージョンが最新かどうか
  ///
  /// 最新でない場合: アップデートのお知らせを表示
  ///
  /// 必ずしも最新のバージョンでないとこのフラグが`true`になるわけではない
  ///
  /// アップデートのお知らせを出す必要性ベースでFirebase Consoleで値を設定
  ///
  /// オフラインの場合は、バイパスする
  static const String isLatestAppVersion = 'is_latest_app_version';

  /// API導入後に廃止予定: お知らせJSON URL
  static const String announcementsUrl = 'announcements_url';

  /// HOPE連携マニュアルURL
  static const String assignmentSetupUrl = 'assignment_setup_url';

  /// フィードバックフォームURL
  static const String feedbackFormUrl = 'feedback_form_url';

  /// 利用規約URL
  static const String termsOfServiceUrl = 'terms_of_service_url';

  /// プライバシーポリシーURL
  static const String privacyPolicyUrl = 'privacy_policy_url';

  /// アプリストアURL
  static const String appStorePageUrl = 'app_store_page_url';
}
