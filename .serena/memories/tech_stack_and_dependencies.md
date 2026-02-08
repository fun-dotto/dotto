# Dotto 技術スタックと依存関係

## Flutter SDKバージョン
- SDK: ^3.9.2
- アプリバージョン: 1.6.0+0

## 主要依存関係（pubspec.yaml）

### 状態管理
- **flutter_riverpod**: ^3.0.3 - 状態管理フレームワーク
- **riverpod_annotation**: ^3.0.3 - Riverpodコード生成アノテーション
- **riverpod_generator**: ^3.0.3 (dev) - Riverpod コード生成

### イミュータブルデータ
- **freezed_annotation**: ^3.0.0 - Freezedアノテーション
- **freezed**: ^3.0.6 (dev) - イミュータブルクラス生成
- **json_annotation**: ^4.9.0 - JSON シリアライゼーション
- **json_serializable**: ^6.7.1 (dev) - JSON コード生成

### Firebase
- **firebase_core**: ^3.8.0 - Firebase初期化
- **firebase_auth**: ^5.4.0 - 認証
- **firebase_analytics**: ^11.5.2 - アナリティクス
- **firebase_crashlytics**: ^4.3.9 - クラッシュレポート
- **firebase_messaging**: ^15.2.0 - プッシュ通知
- **firebase_storage**: ^12.4.0 - ストレージ
- **firebase_database**: ^11.2.0 - Realtime Database
- **firebase_remote_config**: ^5.4.7 - リモート設定
- **firebase_app_check**: ^0.3.2 - App Check
- **cloud_firestore**: ^5.5.0 - Firestore

### HTTP/API
- **dio**: ^5.9.0 - HTTPクライアント
- **http**: ^1.4.0 - HTTP通信
- **openapi**: (path: ./api) - OpenAPI生成クライアント

### UI/Widget
- **dotto_design_system**: (path: ./dotto_design_system) - デザインシステム
- **carousel_slider**: ^5.0.0 - カルーセル
- **flutter_svg**: ^2.0.9 - SVG表示
- **flutter_slidable**: ^4.0.0 - スライド可能リスト
- **flutter_staggered_grid_view**: ^0.7.0 - グリッドビュー
- **flutter_rating_bar**: ^4.0.1 - 評価バー
- **shimmer_animation**: ^2.2.2 - シマーエフェクト
- **settings_ui**: ^2.0.2 - 設定画面UI

### ナビゲーション/ルーティング
- **app_links**: ^6.4.0 - ディープリンク

### 認証
- **google_sign_in**: ^6.2.2 - Google認証

### 通知
- **flutter_local_notifications**: ^19.0.0 - ローカル通知
- **timezone**: ^0.10.0 - タイムゾーン処理

### ストレージ/データベース
- **sqflite**: ^2.3.3 - SQLiteデータベース
- **shared_preferences**: ^2.2.3 - キーバリューストレージ
- **path_provider**: ^2.1.3 - ファイルパス取得
- **minio**: ^3.5.6 - MinIO (オブジェクトストレージ)

### 日時/ロケール
- **intl**: ^0.20.2 - 国際化
- **flutter_localizations**: (sdk) - Flutter多言語対応
- **flutter_datetime_picker_plus**: ^2.2.0 - 日時ピッカー

### 位置情報
- **geolocator**: ^14.0.0 - GPS位置情報

### ユーティリティ
- **package_info_plus**: ^8.1.0 - パッケージ情報取得
- **url_launcher**: ^6.2.6 - URL起動
- **share_plus**: ^10.1.0 - シェア機能
- **path**: ^1.9.0 - パス操作
- **collection**: ^1.18.0 - コレクションユーティリティ

### UI特殊
- **flutter_overboard**: ^3.1.3 - オンボーディング
- **flutter_pdfview**: ^1.4.0 - PDF表示

### 開発依存関係
- **build_runner**: ^2.10.5 - コード生成ランナー
- **flutter_test**: (sdk) - テストフレームワーク
- **mockito**: ^5.4.0 - モックライブラリ
- **flutter_lints**: ^5.0.0 - Lint
- **very_good_analysis**: ^8.0.0 - 詳細な静的解析
- **flutter_launcher_icons**: ^0.14.1 - アイコン生成
- **flutter_native_splash**: ^2.4.5 - スプラッシュスクリーン生成

## ビルドツール・CI/CD

### タスクランナー
- **Task**: Taskfile.yml でタスク管理

### Fastlane
- iOS/Androidのビルド・デプロイ自動化
  - Firebase App Distribution
  - TestFlight (iOS)
  - Google Play (Android)

### CI
- GitHub Actions (`ci.yaml`)

### コード生成
- **OpenAPI Generator**: `openapi/openapi.yaml` からDart Dioクライアント生成
- **build_runner**: Freezed、Riverpod、JSONシリアライゼーション自動生成

## パッケージマネージャー
- **mise**: 開発環境管理 (`mise.toml`)
- **Bundler**: Ruby依存関係管理 (Fastlane用)

## アイコン・スプラッシュ
- **flutter_launcher_icons**: `assets/icon1024x1024.png` からアプリアイコン生成
- **flutter_native_splash**: `assets/icon768x768.png` からスプラッシュスクリーン生成

## 多言語対応
- **l10n**: `l10n.yaml` で設定
- **flutter_localizations**: Flutter公式多言語対応

## 静的解析
- **analysis_options.yaml**: Lint設定
- **very_good_analysis**: 厳格な静的解析ルール

## 環境変数
- **.env**: 環境変数ファイル（Gitignore）
- **.env.example**: 環境変数サンプル
- 実行時に `--dart-define-from-file=./.env` で読み込み

## ディレクトリ構成の詳細

### lib/
- **feature/**: 機能別モジュール（13個のFeature）
  - home, announcement, assignment, bus, funch, github_contributor, map, search_course, setting, timetable, kamoku_detail, root, debug
- **domain/**: エンティティ、enum、定数
- **repository/**: Repository実装
- **controller/**: コントローラー
- **widget/**: 共通Widget
- **helper/**: ヘルパー関数
- **api/**: API関連
- **l10n/**: 多言語対応

### サブプロジェクト
- **dotto_design_system/**: 独立したデザインシステムパッケージ（Storybook付き）
- **api/**: OpenAPI Generator生成コード

### ネイティブ
- **android/**: Android固有コード、Fastlane設定
- **ios/**: iOS固有コード、Fastlane設定

### ドキュメント
- **dotto-docs/public/app-dev-onboarding/**: オンボーディング資料
  - **codebase/**: Feature、Architecture
  - **development/**: Project、Branch、Commit、PR
  - **setup/**: 開発環境セットアップ

---
© 2025 Dotto
