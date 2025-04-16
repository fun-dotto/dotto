# [macOS] Xcode

## Xcodes をインストール

Xcode を管理するためのアプリケーションです。Homebrew を使ってインストールします。  
Xcode を高速にインストールするためのパッケージ `aria2` も合わせてインストールします。

```
% brew install xcodes aria2
```

## Xcode をインストール

最新版の Xcode を Xcodes を使ってインストールします。

以下のコマンドで最新版のバージョンを調べます。  
下記の例では、16.3 が最新です。Beta、Release Candidate が入っているバージョンは、安定版ではないので、インストールすることは避けます。

```
% xcodes list
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
```

最新バージョンを指定してインストールします。  
下記の例では、`16.3` をインストールします。

```
% xcodes install 16.3 --experimental-unxip
```

iOS ランタイムの最新版をインストールします。  
下記の例では、`iOS 18.4` をインストールします。

```
% xcodes runtimes
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
