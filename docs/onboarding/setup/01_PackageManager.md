# [macOS] Homebrew

macOS のためのパッケージ管理ツールです。

`ターミナル.app` (英: `Terminal.app`) を起動します。

## Command Line Tools をインストール

```zsh
xcode-select --install
```

## Homebrew をインストール

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```zsh
echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile
eval $(/opt/homebrew/bin/brew shellenv)
```

# [Windows] Winget

Windows のためのパッケージ管理ツールです。

## WinGet をインストール

[Microsoft Store](https://apps.microsoft.com/detail/9nblggh4nns1?hl=ja-JP&gl=JP) からインストールします。
