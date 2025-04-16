# [macOS] Homebrew をインストール

`ターミナル.app` (英: `Terminal.app`) を起動します。

## Command Line Tools をインストール

```
% xcode-select --install
```

## [Homebrew](https://brew.sh/ja/) とは

macOS のためのパッケージ管理ツールです。

## インストール方法

```
% /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```
% echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile
% eval $(/opt/homebrew/bin/brew shellenv)
```

```
% brew -v
Homebrew X.X.X
```
