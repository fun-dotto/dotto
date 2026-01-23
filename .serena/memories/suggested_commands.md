# Dotto 開発コマンド一覧

このファイルは、Dottoプロジェクトでの開発時に使用する重要なコマンドをまとめたものです。

## タスクランナー (Task)

プロジェクトでは `task` コマンドを使用してタスクを管理します。
利用可能なコマンド一覧を表示:
```bash
task
# または
task --list-all
```

## セットアップ・インストール

### 依存関係のインストール
```bash
# メインプロジェクトのみ
task install

# 全プロジェクト（design_system、api含む）
task install-all
```

### OpenAPIコード生成
```bash
task generate-openapi
```

## ビルド・コード生成

### build_runner実行（Freezed、Riverpod、JSON生成）
```bash
# 1回だけ実行
task build

# 全プロジェクトで実行
task build-all

# ウォッチモード（ファイル変更を監視）
task watch

# 全プロジェクトでウォッチモード
task watch-all
```

直接実行する場合:
```bash
flutter run build_runner build --delete-conflicting-outputs
flutter run build_runner watch --delete-conflicting-outputs
```

## 実行

### アプリ起動
```bash
# メインアプリ
task run

# Storybook（デザインシステム）
task run-storybook
```

直接実行する場合:
```bash
flutter run --dart-define-from-file=./.env
```

## テスト

### テスト実行
```bash
# 通常のテスト
task test

# カバレッジレポート付き
task test-with-coverage
```

直接実行する場合:
```bash
flutter test
flutter test --coverage
```

## 静的解析・Lint

### コード解析
```bash
task analyze
```

直接実行する場合:
```bash
flutter analyze ./lib/ ./test/
```

**使用しているLintルール**: `very_good_analysis`
- 厳格な静的解析ルールを適用
- `public_member_api_docs: false` で公開API文書化要件を無効化

## クリーン

### ビルドファイルのクリーンアップ
```bash
task clean
```

直接実行する場合:
```bash
flutter clean
```

## ビルド（リリース）

### iOSリリースビルド
```bash
task build-ios
```

### Androidリリースビルド（appbundle）
```bash
task build-android
```

## デプロイ

### Firebase App Distribution
```bash
# iOS
task deploy-ios-firebase-app-distribution

# Android
task deploy-android-firebase-app-distribution
```

### TestFlight (iOS)
```bash
task deploy-ios-testflight
```

### Google Play (Android)
```bash
task deploy-android-google-play
```

## バージョン管理

### ビルド番号のインクリメント
```bash
task bump-build
```

### バージョンアップ
```bash
# パッチバージョン (1.6.0 -> 1.6.1)
task bump-patch

# マイナーバージョン (1.6.0 -> 1.7.0)
task bump-minor

# メジャーバージョン (1.6.0 -> 2.0.0)
task bump-major
```

## Git操作

### ブランチ作成
```bash
# mainを最新に更新
git checkout main
git pull origin main

# 新しいブランチを作成
git checkout -b feature/your-feature-name
```

### コミット
```bash
# 変更確認
git status
git diff

# ステージング
git add .

# コミット
git commit -m "コミットメッセージ"
```

### プッシュとPR作成
```bash
# リモートにプッシュ
git push origin <ブランチ名>

# その後、GitHubでPull Requestを作成
```

## iOS開発

### 証明書取得（開発用）
```bash
task match-development
```

### iOSデバイス登録
```bash
task register-ios-device name="デバイス名" udid="UDID"
```

## よく使うFlutterコマンド

### 依存関係取得
```bash
flutter pub get
```

### デバイス一覧
```bash
flutter devices
```

### パッケージアップグレード
```bash
flutter pub upgrade
```

### Flutterバージョン確認
```bash
flutter --version
```

## 開発環境

### Mise（ツールバージョン管理）
```bash
# 設定確認
mise current

# インストール
mise install
```

### Fastlane（iOS/Android）
```bash
# iOSディレクトリで実行
cd ios
fastlane <lane_name>

# Androidディレクトリで実行
cd android
fastlane <lane_name>
```

## その他

### OpenAPI生成（詳細）
```bash
openapi-generator generate -i ./openapi/openapi.yaml -g dart-dio -o ./api
```

### カバレッジレポート表示
```bash
# テスト実行後
open coverage/html/index.html
```

---

**重要**: 
- コマンド実行前に `task install` で依存関係をインストール
- コード変更後は `task build` でコード生成を実行
- 環境変数は `.env` ファイルに設定（`.env.example` を参照）

© 2025 Dotto
