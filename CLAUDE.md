# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## プロジェクト概要

**Dotto**は、FUN（公立はこだて未来大学）の学生向け Flutter モバイルアプリです。以下の機能を提供します：

- 教室空き状況付きキャンパスマップ
- 科目情報検索（kamoku）
- 課題管理（kadai）
- 個人時間割とバススケジュール
- ニュースと通知

## 開発コマンド

### セットアップとインストール

```bash
# fvm（Flutter Version Manager）を使用して依存関係をインストール
make install

# fastlane依存関係をインストール
make bundle-install
```

### 開発ワークフロー

```bash
# アプリを実行
make run

# コード生成（freezedモデル、JSON シリアライゼーション）
make build

# テストを実行
make test

# カバレッジレポート付きテストを実行
make test-with-coverage

# コードの問題を分析
make analyze

# ビルドアーティファクトをクリーンアップ
make clean
```

### プロダクション用ビルド

```bash
# iOSリリースビルド
make build-ios

# Androidリリースビルド
make build-android
```

### バージョン管理

```bash
# ビルド番号を上げる
make bump-build

# パッチバージョンを上げる
make bump-patch

# マイナーバージョンを上げる
make bump-minor

# メジャーバージョンを上げる
make bump-major
```

### デプロイ

```bash
# Firebase App Distributionにデプロイ
make deploy-ios-firebase-app-distribution
make deploy-android-firebase-app-distribution

# App Store/Play Storeにデプロイ
make deploy-ios-testflight
make deploy-android-play-store
```

## アーキテクチャ

### 技術スタック

- **Flutter/Dart**: モバイルアプリフレームワーク
- **Firebase**: バックエンドサービス（Firestore、Auth、Storage、Messaging）
- **Riverpod**: 状態管理
- **Fastlane**: CI/CD 自動化
- **FVM**: Flutter バージョン管理

### プロジェクト構造

```
lib/
├── app.dart                 # タブナビゲーション付きメインアプリウィジェット
├── main.dart               # Firebaseセットアップ付きアプリエントリーポイント
├── importer.dart           # 共通インポート
├── components/             # 再利用可能なUIコンポーネント
├── controller/             # Riverpod状態コントローラー
├── domain/                # データモデルとenum
├── feature/               # 機能モジュール
│   ├── kamoku_detail/     # 科目詳細ビュー
│   ├── kamoku_search/     # 科目検索機能
│   ├── map/              # 教室空き状況付きキャンパスマップ
│   ├── my_page/          # 時間割、バス、ニュース付きホーム画面
│   └── settings/         # アプリ設定
├── repository/           # データアクセス層
├── screens/             # 独立したスクリーン
└── theme/              # アプリテーマ
```

### 主要なアーキテクチャパターン

- **機能ベースの組織**: 各主要機能は、controller、domain、repository、widget サブディレクトリを持つ独自のディレクトリを持つ
- **Riverpod 状態管理**: 機能間での状態管理にプロバイダーを使用
- **リポジトリパターン**: データアクセスはリポジトリクラスを通じて抽象化される
- **タブベースナビゲーション**: メインアプリは個別の Navigator スタックを持つボトムタブナビゲーションを使用

### 状態管理

- 状態管理に Riverpod を使用
- 主要なプロバイダー：
  - `tabItemProvider`: 現在のタブ選択を管理
  - `userProvider`: ユーザー認証状態
  - 各モジュールの機能固有プロバイダー

### ナビゲーション

- 5 つのメインタブを持つタブベースナビゲーション：
  - ホーム（ホーム）: 時間割、バススケジュール、ニュース
  - マップ（マップ）: 教室空き状況付きキャンパスマップ
  - 科目情報（科目情報）: 科目検索と詳細
  - 課題（課題）: 課題管理
  - 設定（設定）: アプリ設定

## Firebase 統合

アプリは Firebase サービスと統合されています：

- **Firestore**: 科目データ、課題、ニュース
- **Firebase Auth**: ユーザー認証
- **Firebase Storage**: ファイルストレージ
- **Firebase Messaging**: プッシュ通知
- **Firebase App Check**: アプリの整合性検証

## 開発ノート

### コード生成

- イミュータブルデータクラスに`freezed`を使用
- JSON シリアライゼーションに`json_serializable`を使用
- モデルを変更した後は`make build`を実行

### テスト

- `test/`ディレクトリにユニットテスト
- 基本テストには`make test`を実行
- カバレッジレポートには`make test-with-coverage`を実行

### 多言語化

- アプリは日本語（`ja`）と英語（`en`）をサポート
- デフォルトロケールは日本語

### 環境設定

- 開発環境変数に`.env.dev`を使用
- FVM で Flutter バージョンの一貫性を管理

## コードスタイル

- Flutter/Dart の慣習に従う
- コード分析に`flutter_lints`を使用
- 日本語のコメントと UI テキスト（日本の大学向けアプリ）
- 一貫したファイル命名: ファイルには snake_case、クラスには PascalCase
- **重要**: 日本語での出力は必ず UTF-8 エンコーディングで行う

## 開発ルール

- **重要**: ファイルを変更した際は必ずコミットを作成する
- コミットメッセージは日本語で記述し、変更内容を簡潔に説明する
- 機能追加やバグ修正完了後は適切なコミットメッセージでコミットする

## 一般的なタスク

### 新機能の追加

1. `lib/feature/`下に機能ディレクトリを作成
2. サブディレクトリを追加: `controller/`, `domain/`, `repository/`, `widget/`
3. 状態管理のための Riverpod プロバイダーを実装
4. 必要に応じてナビゲーションルートを追加
5. コード生成を使用する場合は`make build`を実行

### データモデルの変更

1. `domain/`ディレクトリのモデルクラスを更新
2. 必要に応じて`freezed`アノテーションを追加
3. `make build`を実行してコードを再生成
4. それに応じてリポジトリメソッドを更新

### 新しい依存関係の追加

1. `pubspec.yaml`に追加
2. `make install`を実行
3. 関連ファイルでインポートを更新
