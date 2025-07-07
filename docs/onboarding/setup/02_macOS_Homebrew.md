# [macOS] Homebrew

`ターミナル.app` (英: `Terminal.app`) を起動します。

## Command Line Tools をインストール

```Bash
xcode-select --install
```

## [Homebrew](https://brew.sh/ja/) とは

macOS のためのパッケージ管理ツールです。

## Homebrew をインストール

```Bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```Bash
echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile
```
```Bash
eval $(/opt/homebrew/bin/brew shellenv)
```

```Bash
brew -v
```

期待される出力
```
Homebrew X.X.X
```
