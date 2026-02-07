# Dotto プロジェクト概要

## プロジェクト説明
**Dotto** は、公立はこだて未来大学の情報をまとめた Flutter モバイルアプリケーションです。
学生向けに、時間割、課題管理、バス時刻表、学食メニュー、キャンパスマップなどの機能を提供します。

**バージョン**: 1.6.0+0  
**SDKバージョン**: ^3.9.2

## アーキテクチャ

### MVVM + UseCase パターン

```
UI Layer: View --> ViewModel
Domain Layer: ViewModel --> UseCase --> Entity
Data Layer: UseCase --> Repository --> (DottoAPI / Firebase)
```

- **View**: 1画面 = 1 View。StatefulWidgetは使用せず、状態はViewModelで管理。子Widgetも状態を持たない
- **ViewModel**: Viewの状態を保持・操作。Riverpod Providerで管理
- **UseCase**: ViewModelとRepositoryの橋渡し
- **Repository**: APIレスポンスをDomain Entityに変換。抽象インターフェース(abstract class)として定義

### 主要技術スタック

- **状態管理**: Riverpod (flutter_riverpod, riverpod_annotation)
- **イミュータブルデータ**: freezed (値型のように扱える構造体生成)
- **API**: OpenAPI Generator (Dio)
- **バックエンド**: Firebase (Auth, Firestore, Storage, Analytics, Crashlytics, Messaging, Remote Config)
- **ビルドツール**: build_runner
- **タスクランナー**: Task (Taskfile.yml)

## プロジェクト構造

```
dotto-flutter/
├── lib/
│   ├── feature/          # 各機能のScreen、ViewModel、UseCase
│   ├── domain/           # エンティティ、列挙型、定数
│   ├── repository/       # Repository実装
│   ├── controller/       # コントローラー
│   ├── widget/           # 共通Widget
│   ├── helper/           # ヘルパー関数
│   ├── api/              # API関連
│   ├── l10n/             # 多言語対応
│   ├── main.dart         # エントリーポイント
│   └── app.dart          # アプリルート
├── dotto_design_system/  # デザインシステム（独立パッケージ）
├── api/                  # OpenAPI生成コード
├── dotto-docs/            # ドキュメント（サブモジュール）
│   └── public/
│       └── app-dev-onboarding/  # オンボーディング資料
│           ├── codebase/        # コードベース説明
│           └── development/     # 開発フロー
├── android/              # Androidネイティブ
├── ios/                  # iOSネイティブ
├── assets/               # 画像・リソース
└── Taskfile.yml          # タスク定義
```

## Feature一覧

各Featureは `lib/feature/{feature_name}/` 配下に配置。

| Feature | アーキテクチャ | データソース | 主要機能 |
|---------|---------------|-------------|---------|
| **Home** | None | - | 時間割、バス情報、学食メニュー、学年暦PDF、プッシュ通知 |
| **Announcement** | MVVM+UseCase | Dotto API | お知らせ一覧、Firebase連携 |
| **Assignment** | None | Firebase | HOPE連携課題管理、締切通知 |
| **Bus** | None | Firebase | バス時刻表、リアルタイム更新 |
| **Funch** | None | Transfering | 学食メニュー、価格情報 |
| **GitHub Contributor** | MVVM+UseCase | GitHub API | 開発者一覧表示 |
| **Map** | MVVM+UseCase | Firebase | キャンパスマップ、教室検索、使用中教室表示 |
| **Search Course** | None | Local | 科目検索、絞り込み |
| **Setting** | None | - | ログイン、学年・コース設定、HOPE連携、フィードバック |
| **Timetable** | None | Firebase | 時間割編集、休講・補講情報 |
| **Kamoku Detail** | None | Firebase | シラバス、レビュー、過去問 |

### Feature構造

```
feature/{feature_name}/
  {feature_name}_screen.dart      # Screen (View)
  {feature_name}_viewmodel.dart   # ViewModel
  {feature_name}_usecase.dart     # UseCase
  widget/                         # Feature固有Widget
```

## 開発フロー

### ブランチ戦略

- **main**: メインブランチ
- **feature/**: 新機能追加（例: `feature/user-profile`）
- **fix/**: バグ修正（例: `fix/map-display-on-ipad`）
- **docs/**: ドキュメント更新（例: `docs/onboarding`）
- **issue/**: Issue番号含む（例: `issue/109-map-vending-machine`）

ブランチ名は小文字とハイフン（`-`）を使用。

### コミットルール

- **日本語**でメッセージを記述
- **最小変更単位**でコミット
- **形式**:
  - 追加: `Add 機能名` / `機能名を追加`
  - 更新: `Update 対象` / `対象を更新`
  - 修正: `Fix 問題` / `問題を修正`
  - リファクタリング: `Refactor 対象`
- **Issue連携**: `機能名: 説明 (#Issue番号)` 例: `Timetable: 時刻表示オプションを追加 (#332)`

## 開発コマンド（Taskfile.yml）

### インストール・セットアップ
- `task install`: 依存関係インストール
- `task install-all`: 全プロジェクト（design_system、api含む）インストール

### ビルド・コード生成
- `task generate-openapi`: OpenAPIコード生成
- `task build`: build_runner実行（コード生成）
- `task build-all`: 全プロジェクトのbuild_runner実行
- `task watch`: build_runnerをウォッチモードで実行

### 実行
- `task run`: Flutterアプリ起動
- `task run-storybook`: Storybookアプリ起動

### テスト・解析
- `task test`: テスト実行
- `task test-with-coverage`: カバレッジレポート付きテスト
- `task analyze`: Dartコード解析

### ビルド（リリース）
- `task build-ios`: iOSリリースビルド
- `task build-android`: Androidリリースビルド（appbundle）

### デプロイ
- `task deploy-ios-firebase-app-distribution`: iOS Firebase App Distribution
- `task deploy-android-firebase-app-distribution`: Android Firebase App Distribution
- `task deploy-ios-testflight`: iOS TestFlight
- `task deploy-android-google-play`: Android Google Play

### バージョン管理
- `task bump-build`: ビルド番号インクリメント
- `task bump-patch`: パッチバージョンアップ
- `task bump-minor`: マイナーバージョンアップ
- `task bump-major`: メジャーバージョンアップ

## 設計原則

- **DRY原則**: 重複を避ける
- **SOLID原則**: オブジェクト指向設計
- **アーキテクチャ準拠**: 新機能は `dotto-docs/public/app-dev-onboarding/codebase/02_Architecture.md` に従う
- **ドキュメント参照**: ブランチ・コミット・PRルールは `dotto-docs/public/app-dev-onboarding/development/` を参照

## 関連ドキュメント

- アーキテクチャ詳細: `dotto-docs/public/app-dev-onboarding/codebase/02_Architecture.md`
- Feature詳細: `dotto-docs/public/app-dev-onboarding/codebase/01_Feature.md`
- ブランチ運用: `dotto-docs/public/app-dev-onboarding/development/02_Branch.md`
- コミットルール: `dotto-docs/public/app-dev-onboarding/development/03_Commit.md`
- Pull Request: `dotto-docs/public/app-dev-onboarding/development/04_PR.md`

---
© 2025 Dotto
