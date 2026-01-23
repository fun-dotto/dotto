# Darwin (macOS) システムコマンド

このファイルは、macOS（Darwin）環境での開発で使用する基本的なシステムコマンドをまとめたものです。

## 基本コマンド

### ディレクトリ操作

```bash
# カレントディレクトリ表示
pwd

# ディレクトリ一覧
ls
ls -la      # 詳細表示（隠しファイル含む）
ls -lh      # ファイルサイズを人間が読みやすい形式で表示

# ディレクトリ移動
cd <ディレクトリ>
cd ..       # 親ディレクトリへ移動
cd ~        # ホームディレクトリへ移動
cd -        # 直前のディレクトリへ移動

# ディレクトリ作成
mkdir <ディレクトリ名>
mkdir -p path/to/deep/directory  # 親ディレクトリも含めて作成

# ディレクトリ削除
rmdir <ディレクトリ名>              # 空のディレクトリ削除
rm -rf <ディレクトリ名>             # ディレクトリと中身を削除（注意！）
```

### ファイル操作

```bash
# ファイル表示
cat <ファイル名>          # 全体表示
head <ファイル名>         # 先頭10行表示
head -n 20 <ファイル名>   # 先頭20行表示
tail <ファイル名>         # 末尾10行表示
tail -f <ファイル名>      # ファイルの変更を監視（ログファイル等）
less <ファイル名>         # ページャーで表示（q で終了）

# ファイルコピー
cp <元ファイル> <先>
cp -r <元ディレクトリ> <先>  # ディレクトリごとコピー

# ファイル移動・リネーム
mv <元> <先>

# ファイル削除
rm <ファイル名>
rm -i <ファイル名>        # 確認してから削除
rm -f <ファイル名>        # 強制削除

# ファイル作成
touch <ファイル名>

# ファイル検索
find . -name "*.dart"             # .dartファイルを検索
find . -type f -name "test*"      # testで始まるファイルを検索
find . -type d -name "feature"    # featureという名前のディレクトリを検索
```

### テキスト検索

```bash
# ファイル内検索
grep "検索文字列" <ファイル名>
grep -r "検索文字列" .             # カレントディレクトリ以下を再帰的に検索
grep -i "検索文字列" <ファイル名>   # 大文字小文字を区別しない
grep -n "検索文字列" <ファイル名>   # 行番号付きで表示
grep -v "検索文字列" <ファイル名>   # マッチしない行を表示

# 複数パターン
grep -E "pattern1|pattern2" <ファイル名>

# ripgrep（高速な検索ツール、インストールが必要）
rg "検索文字列"
rg -i "検索文字列"       # 大文字小文字を区別しない
rg -t dart "検索文字列"  # Dartファイルのみ検索
```

### プロセス管理

```bash
# プロセス一覧
ps aux
ps aux | grep flutter     # flutterに関連するプロセスを検索

# リソース監視
top                       # プロセス一覧とリソース使用状況
htop                      # topの改良版（インストールが必要）

# プロセス終了
kill <PID>                # プロセスID指定で終了
kill -9 <PID>             # 強制終了
killall <プロセス名>       # 名前指定で全て終了
```

### ネットワーク

```bash
# ネットワーク接続確認
ping google.com
ping -c 4 google.com      # 4回だけ送信

# ポート確認
lsof -i :8080             # ポート8080を使用しているプロセス
netstat -an | grep 8080   # ポート8080の状態確認

# ファイルダウンロード
curl -O <URL>             # URLからファイルダウンロード
wget <URL>                # wgetでダウンロード（インストールが必要）
```

## Git操作

```bash
# 状態確認
git status
git log                   # コミット履歴
git log --oneline         # 1行で表示
git log --graph           # グラフ表示

# ブランチ操作
git branch                # ブランチ一覧
git branch <ブランチ名>    # 新規ブランチ作成
git checkout <ブランチ名>  # ブランチ切り替え
git checkout -b <ブランチ名>  # 作成して切り替え
git branch -d <ブランチ名>    # ブランチ削除

# 変更確認
git diff                  # 変更差分
git diff --staged         # ステージング済みの差分
git diff <ブランチ1> <ブランチ2>  # ブランチ間の差分

# コミット
git add .                 # 全ファイルをステージング
git add <ファイル名>       # 特定ファイルをステージング
git commit -m "メッセージ"
git commit --amend        # 直前のコミット修正

# リモート操作
git pull                  # リモートから取得してマージ
git push                  # リモートへプッシュ
git fetch                 # リモートから取得（マージしない）

# 変更取り消し
git checkout -- <ファイル名>  # ファイルの変更を取り消し
git reset HEAD <ファイル名>   # ステージングを取り消し
git reset --hard HEAD     # 全変更を破棄（注意！）
```

## macOS固有

### ファイル・アプリケーション操作

```bash
# Finderで開く
open .                    # カレントディレクトリをFinderで開く
open <ファイル名>          # デフォルトアプリで開く
open -a "Visual Studio Code" <ファイル名>  # 指定アプリで開く

# クリップボード操作
pbcopy < <ファイル名>      # ファイル内容をクリップボードにコピー
pbpaste                   # クリップボードの内容を出力
echo "text" | pbcopy      # テキストをクリップボードにコピー
```

### システム情報

```bash
# macOSバージョン
sw_vers

# システム情報
system_profiler SPSoftwareDataType
system_profiler SPHardwareDataType

# ディスク使用状況
df -h                     # 全ディスク
du -sh *                  # カレントディレクトリ内の各項目のサイズ
du -sh <ディレクトリ>      # 特定ディレクトリのサイズ
```

### パッケージ管理（Homebrew）

```bash
# Homebrewでのインストール
brew install <パッケージ名>
brew install --cask <アプリ名>  # GUIアプリのインストール

# アップデート
brew update               # Homebrew自体を更新
brew upgrade              # 全パッケージ更新
brew upgrade <パッケージ名>  # 特定パッケージ更新

# 検索・情報
brew search <パッケージ名>
brew info <パッケージ名>

# 削除
brew uninstall <パッケージ名>

# クリーンアップ
brew cleanup              # 古いバージョンを削除
```

## 便利なコマンド組み合わせ

### パイプとリダイレクト

```bash
# パイプ（|）: コマンドの出力を次のコマンドの入力に
ls -la | grep "dart"
git log | head -n 10

# リダイレクト（>）: 出力をファイルに保存
ls -la > file_list.txt
echo "text" >> file.txt   # 追記

# 入力リダイレクト（<）
sort < file.txt
```

### 検索とフィルタ

```bash
# 特定の拡張子のファイルを検索して行数をカウント
find . -name "*.dart" | xargs wc -l

# プロセスを検索して終了
ps aux | grep flutter | awk '{print $2}' | xargs kill

# ファイル内の特定文字列を含む行を抽出してソート
grep "import" *.dart | sort | uniq
```

## 環境変数

```bash
# 環境変数表示
echo $PATH
echo $HOME
env                       # 全環境変数

# 環境変数設定（現在のシェルセッションのみ）
export VARIABLE_NAME=value

# シェル設定ファイル
~/.zshrc                  # zsh（macOS Catalina以降のデフォルト）
~/.bash_profile           # bash（古いmacOS）

# 設定反映
source ~/.zshrc
```

## Xcode関連

```bash
# Xcodeバージョン確認
xcodebuild -version

# シミュレータ一覧
xcrun simctl list devices

# ビルド
xcodebuild -workspace <workspace> -scheme <scheme> build
```

## トラブルシューティング

### 権限関連

```bash
# 権限確認
ls -l <ファイル名>

# 権限変更
chmod +x <ファイル名>     # 実行権限付与
chmod 644 <ファイル名>    # 読み書き権限設定

# 所有者変更
sudo chown <ユーザー名> <ファイル名>
```

### キャッシュクリア

```bash
# Flutterキャッシュ
flutter clean

# Homebrewキャッシュ
brew cleanup

# Xcodeキャッシュ
rm -rf ~/Library/Developer/Xcode/DerivedData
```

---

**Tips**:
- タブキーで補完機能を活用
- `Ctrl + C` でコマンド中断
- `Ctrl + R` でコマンド履歴検索（zsh/bash）
- `!!` で直前のコマンド実行
- `!$` で直前のコマンドの最後の引数

© 2025 Dotto
