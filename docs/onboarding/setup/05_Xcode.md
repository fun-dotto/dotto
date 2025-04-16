# [macOS] Xcode

## Xcodes をインストール

Xcode を管理するためのアプリケーションです。Homebrew を使ってインストールします。  
Xcode を高速にインストールするためのパッケージ `aria2` も合わせてインストールします。

```
% brew install xcodes aria2
```

## Xcode をインストール

Xcodes で Xcode の最新安定版インストールします。  
下記の例では、16.3 が最新です。`Beta` 、`Release Candidate` が入っているバージョンは、安定版ではないので、インストールすることは避けます。  
下記の例では、`16.3` をインストールします。

```
% xcodes list
...
16.3 Beta (16E5104o)
16.3 Beta 2 (16E5121h)
16.3 Beta 3 (16E5129f)
16.3 Release Candidate (16E137)
16.3 (16E140)
% xcodes install 16.3 --experimental-unxip
```

iOS ランタイムの最新版をインストールします。  
下記の例では、`iOS 18.4` をインストールします。

```
% xcodes runtimes
-- iOS --
...
iOS 18.4
-- watchOS --
...
watchOS 11.4
-- tvOS --
...
tvOS 18.4
-- visionOS --
...
visionOS 2.4

Note: Bundled runtimes are indicated for the currently selected Xcode, more bundled runtimes may exist in other Xcode(s)
% xcodes runtimes install 'iOS 18.4'
```

## rbenv をインストール

Ruby を管理するためのソフトウェアです。Homebrew を使ってインストールします。

```
% brew install rbenv
% echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
% echo 'eval "$(rbenv init -)"' >> ~/.zshrc
% source ~/.zshrc
```

## Ruby をインストール

rbenv を使って、Ruby をインストールします。  
3.3 系の最新バージョンをインストールします。  
下記の例では、`3.3.8` をインストールします。

```
% rbenv install -l
3.1.7
3.2.8
3.3.8
3.4.3
jruby-10.0.0.0
mruby-3.3.0
picoruby-3.0.0
truffleruby-24.2.0
truffleruby+graalvm-24.2.0

Only latest stable releases for each Ruby implementation are shown.
Use `rbenv install --list-all' to show all local versions.
% rbenv install 3.3.8
```

## CocoaPod をインストール

Ruby の gem を使って、CocoaPod をインストールします。

```
% gem update
% gem install cocoapods
```
