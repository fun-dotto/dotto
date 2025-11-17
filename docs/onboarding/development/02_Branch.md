# Branch

## Branch とは

Branch（Branch）は、Git の機能の一つで、コードベースの独立した作業コピーを作成するためのものです。Branch を使用することで、複数の開発者が同時に異なる機能や修正を並行して開発でき、メインのコードベースに影響を与えることなく作業を進めることができます。

## Branch の命名規則

Dotto では、以下の命名規則に従って Branch を作成します：

- **`feature/`**: 新機能を追加する場合
  - 例: `feature/grade`, `feature/user-profile`
- **`fix/`**: バグ修正を行う場合
  - 例: `fix/map-display-on-ipad`, `fix/map-search`
- **`docs/`**: ドキュメントの追加・更新を行う場合
  - 例: `docs/process`, `docs/onboarding`
- **`issue/`**: Issue 番号を含める場合（任意）
  - 例: `issue/109-map-vending-machine`, `issue/67-upload-past-exams`

Branch 名は、スラッシュ（`/`）で区切り、小文字とハイフン（`-`）を使用します。

## Branch の作成方法

1. 最新の `main` Branch に切り替えます：

   ```bash
   git checkout main
   ```

2. 最新の状態に更新します：

   ```bash
   git pull origin main
   ```

3. 新しい Branch を作成して切り替えます：

   ```bash
   git checkout -b feature/your-feature-name
   ```

## Branch の使い方

1. **作業開始時**: タスクを選んだら、対応する Branch を作成します
2. **作業中**: 作成した Branch でコミットを重ねていきます
3. **作業完了時**: Branch をリモートにプッシュし、Pull Request を作成します

[詳細なコミット方法](./03_Commit.md)や [Pull Request](./04_PR.md) の作成方法については、それぞれのドキュメントを参照してください。
