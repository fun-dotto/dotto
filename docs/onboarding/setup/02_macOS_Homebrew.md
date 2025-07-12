# [macOS] Homebrew

`ターミナル.app` (英: `Terminal.app`) を起動します。

## Command Line Tools をインストール

```zsh
xcode-select --install
```

## [Homebrew](https://brew.sh/ja/) とは

macOS のためのパッケージ管理ツールです。

## Homebrew をインストール

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```zsh
echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile
```

```zsh
eval $(/opt/homebrew/bin/brew shellenv)
```

```zsh
brew -v
```

出力例

```
Homebrew X.X.X
```
