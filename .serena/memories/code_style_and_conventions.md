# Dotto コーディングスタイル・規約

このファイルは、Dottoプロジェクトのコーディングスタイル、規約、デザインパターンをまとめたものです。

## 設計原則

### DRY原則（Don't Repeat Yourself）
- コードの重複を避ける
- 共通処理は関数・クラスに抽出

### SOLID原則
- **S**ingle Responsibility Principle: 単一責任の原則
- **O**pen/Closed Principle: 開放/閉鎖の原則
- **L**iskov Substitution Principle: リスコフの置換原則
- **I**nterface Segregation Principle: インターフェース分離の原則
- **D**ependency Inversion Principle: 依存性逆転の原則

## アーキテクチャパターン: MVVM + UseCase

### View（画面）
- **1画面 = 1 View**
- StatefulWidgetは原則使用しない
- 状態はViewModelが管理
- 子Widgetも状態を持たない（Stateless）
- ConsumerWidgetを使用してViewModelをwatch

### ViewModel
- **1 View = 1 ViewModel**
- View の状態を保持・操作
- Riverpod Providerで管理
- `@riverpod` アノテーションを使用
- 状態の構造体はFreezedで定義

### UseCase
- ViewModelとRepositoryの橋渡し
- ビジネスロジックを実装

### Repository
- 抽象インターフェース（abstract class）として定義
- 実装クラスでAPI/Firebase呼び出し
- レスポンスをDomain Entityに変換
- テスト時はモックで上書き可能

## ファイル・ディレクトリ構造

### Feature構造
```
lib/feature/{feature_name}/
  {feature_name}_screen.dart      # View
  {feature_name}_viewmodel.dart   # ViewModel (@riverpod)
  {feature_name}_usecase.dart     # UseCase
  widget/                         # Feature固有Widget
```

### 命名規則
- **ファイル名**: スネークケース `feature_name_screen.dart`
- **クラス名**: パスカルケース `FeatureNameScreen`
- **変数・関数**: キャメルケース `getUserName()`
- **定数**: キャメルケース（private定数は `_` プレフィックス）

## 状態管理: Riverpod

### Provider定義
```dart
@riverpod
class FeatureNameViewModel extends _$FeatureNameViewModel {
  @override
  FeatureNameState build() {
    return const FeatureNameState();
  }
  
  // メソッド定義
}
```

### 状態クラス (Freezed)
```dart
@freezed
class FeatureNameState with _$FeatureNameState {
  const factory FeatureNameState({
    @Default(false) bool isLoading,
    @Default([]) List<Item> items,
  }) = _FeatureNameState;
}
```

### Widget内での使用
```dart
class FeatureNameScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featureNameViewModelProvider);
    // ...
  }
}
```

## イミュータブルデータ: Freezed

### エンティティ定義
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity_name.freezed.dart';
part 'entity_name.g.dart';

@freezed
class EntityName with _$EntityName {
  const factory EntityName({
    required String id,
    required String name,
    @Default(0) int count,
  }) = _EntityName;
  
  factory EntityName.fromJson(Map<String, dynamic> json) =>
      _$EntityNameFromJson(json);
}
```

## Repository パターン

### インターフェース定義
```dart
abstract class FeatureRepository {
  Future<List<Item>> fetchItems();
  Future<void> saveItem(Item item);
}
```

### 実装
```dart
class FeatureRepositoryImpl implements FeatureRepository {
  final ApiClient _apiClient;
  
  FeatureRepositoryImpl(this._apiClient);
  
  @override
  Future<List<Item>> fetchItems() async {
    final response = await _apiClient.getItems();
    return response.map((e) => Item.fromApi(e)).toList();
  }
}
```

### Riverpodでの提供
```dart
@riverpod
FeatureRepository featureRepository(FeatureRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FeatureRepositoryImpl(apiClient);
}
```

## 静的解析・Lint

### 使用しているLintルール
- **very_good_analysis**: 厳格な静的解析ルール
- `analysis_options.yaml` で設定
- `public_member_api_docs: false` - 公開API文書化要件を無効化

### Lint無視
```dart
// 1行だけ無視
// ignore: lint_rule_name
final value = something();

// ファイル全体で無視
// ignore_for_file: lint_rule_name
```

## コメント・ドキュメント

### コメント方針
- **公開APIの文書化は不要**（`public_member_api_docs: false`）
- 複雑なロジックには説明コメントを追加
- TODOコメントは `// TODO: 説明` 形式

### コメント例
```dart
// ユーザーの権限をチェックして、適切な画面に遷移
void navigateBasedOnPermission() {
  // TODO: 権限チェックロジックを実装
}
```

## ブランチ戦略

### ブランチ命名規則
- `feature/`: 新機能追加（例: `feature/user-profile`）
- `fix/`: バグ修正（例: `fix/map-display-on-ipad`）
- `docs/`: ドキュメント更新（例: `docs/onboarding`）
- `issue/`: Issue番号含む（例: `issue/109-map-vending-machine`）

**ルール**: 小文字とハイフン（`-`）のみ使用

## コミットメッセージ

### 形式（日本語）
- **追加**: `Add 機能名` / `機能名を追加`
- **更新**: `Update 対象` / `対象を更新`
- **修正**: `Fix 問題` / `問題を修正`
- **リファクタリング**: `Refactor 対象`

### Issue連携
```
機能名: 説明 (#Issue番号)
```

例:
- `Timetable: 時刻表示オプションを追加 (#332)`
- `Map: 検索できない問題を修正 (#323)`

## Pull Request規約

### 必須項目
- **タイトル**: 5文字以上
- **説明**: 10文字以上（テンプレート使用）
- **Reviewer**: 必須
- **Assignee**: 自分自身を設定（必須）
- **Milestone**: 関連するMilestone設定（必須）

### 1PR1変更の原則
- 1つのPRには1つの論理的変更のみ
- 可能な限り小さなPRを作成
- 500行以上の変更は分割を検討

### UI差分
UI変更がある場合は、Before/Afterのスクリーンショット必須

## テスト

### テストファイル配置
```
test/
  feature/
    {feature_name}/
      {feature_name}_viewmodel_test.dart
      {feature_name}_usecase_test.dart
```

### テスト方針
- ViewModel、UseCaseはテストを書く
- Repositoryはモックで上書き可能に設計
- Widgetテストも推奨

## コード生成

### 必要なコマンド
```bash
# Freezed、Riverpod、JSONシリアライゼーション
task build

# ウォッチモード（開発中推奨）
task watch
```

### 生成ファイル
- `*.freezed.dart`: Freezed生成
- `*.g.dart`: JSON、Riverpod生成
- コミットに含める（`.gitignore`に含めない）

## Firebase

### セキュリティ
- `.env` ファイルは **絶対にコミットしない**
- `.env.example` にサンプルを記載
- 機密情報はFirebase Remote Configで管理

### 初期化
- `lib/firebase_options.dart` で設定
- `main.dart` で初期化

## 国際化（i18n）

### 多言語対応
- `lib/l10n/` 配下に翻訳ファイル
- `l10n.yaml` で設定
- ARBファイル形式使用

## デザインシステム

### dotto_design_system パッケージ
- 独立したパッケージとして管理
- Storybookで確認可能
- 共通Widgetはここに配置

## エラーハンドリング

### 例外処理
```dart
try {
  final result = await repository.fetchData();
  state = state.copyWith(data: result);
} catch (e) {
  // エラーログ
  debugPrint('Error: $e');
  // ユーザーへの通知
  state = state.copyWith(errorMessage: e.toString());
}
```

## パフォーマンス

### Widget再構築の最小化
- `const` コンストラクタを活用
- 不要な`watch`を避ける
- `select`で部分的な監視

### ビルドメソッドの軽量化
- 重い処理はViewModelに移動
- Widget分割で再構築範囲を限定

---

**重要**: 
- 新機能実装時は必ずアーキテクチャパターンに従う
- コード変更後は `task analyze` で静的解析を実行
- PRマージ前にCIが全てパスすることを確認

© 2025 Dotto
