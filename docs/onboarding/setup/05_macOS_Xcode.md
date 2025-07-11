# [macOS] Xcode

## Xcodes をインストール

Xcode を管理するためのアプリケーションです。Homebrew を使ってインストールします。  
Xcode を高速にインストールするためのパッケージ `aria2` も合わせてインストールします。

```zsh
brew install xcodes aria2
```

## Xcode をインストール

Xcodes で Xcode の最新安定版インストールします。  
下記の例では、16.4 が最新です。`Beta` 、`Release Candidate` が入っているバージョンは、安定版ではないので、インストールすることは避けます。  
下記の例では、`16.4` をインストールします。

```zsh
xcodes list
```

出力例
```
...
16.0 Beta (16A5171c)
16.0 Beta 2 (16A5171r)
16.0 Beta 3 (16A5202i)
16.0 Beta 4 (16A5211f)
16.0 Beta 5 (16A5221g)
16.0 Beta 6 (16A5230g)
16.0 Release Candidate (16A242)
16.0 (16A242d)
16.1 Beta (16B5001e)
16.1 Beta 2 (16B5014f)
16.1 Beta 3 (16B5029d)
16.1 (16B40)
16.2 Beta (16B5100e)
16.2 Beta 2 (16C5013f)
16.2 Beta 3 (16C5023f)
16.2 Release Candidate (16C5031c)
16.2 (16C5032a)
16.3 Beta (16E5104o)
16.3 Beta 2 (16E5121h)
16.3 Beta 3 (16E5129f)
16.3 Release Candidate (16E137)
16.3 (16E140)
16.4 Beta (16F1t)
16.4 (16F6)
```
```zsh
xcodes install 16.4
```

## SDK をインストール

iOS SDK の最新版をインストールします。  
下記の例では、`iOS 18.5` をインストールします。

```zsh
xcodes runtimes
```
以下は出力例
```
-- iOS --
...
iOS 18.5
-- watchOS --
...
watchOS 11.5
-- tvOS --
...
tvOS 18.5
-- visionOS --
...
visionOS 2.5

Note: Bundled runtimes are indicated for the currently selected Xcode, more bundled runtimes may exist in other Xcode(s)
```
```zsh
xcodes runtimes install 'iOS 18.5'
```
