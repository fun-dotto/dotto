# Flutter

Flutter とは、iOS、macOS、Android、Windows、Web など、複数のプラットフォームに対応したアプリケーションを 1 つのコードで開発できる、Google によって開発されたフレームワークです。開発には、Dart という言語が使われます。

## [macOS] Flutter をインストール

ターミナル.app を起動します。

Flutter のバージョンを管理するためのアプリケーション`fvm`をインストールします。

```
% brew tap leoafarias/fvm
% brew install fvm
```

Flutter の最新バージョンを確認します。

```
% fvm releases
```

Flutter の最新バージョンをインストールします。

```
% fvm install <最新バージョン番号>
% fvm global <最新バージョン番号>
```

パスを通します。

```
% echo 'export PATH="$HOME/fvm/default/bin:$PATH"' >> ~/.zshrc
% echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
% echo '[[ -f /Users/kantacky/.dart-cli-completion/zsh-config.zsh ]] && . /Users/kantacky/.dart-cli-completion/zsh-config.zsh || true' >> ~/.zshrc
% source ~/.zshrc
```

Flutter のバージョン番号が表示されれば成功です。

```
% flutter --version
Flutter 3.29.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision ea121f8859 (9 days ago) • 2025-04-11 19:10:07 +0000
Engine • revision cf56914b32
Tools • Dart 3.7.2 • DevTools 2.42.3
```

Flutter に必要な環境が整っているかどうかを確認します。

```
% flutter doctor
```

Android Studio を使う場合は、ライセンスを確認して同意します。

```
% flutter doctor --android-licenses
```

## [Windows] Flutter をインストール

`Visual Studio Code`を起動します。

`Ctrl + Shift + P`を実行します。

表示されたテキストボックスに`> Flutter: New Project`と入力します。

右下にプロンプトが出てきたら、`Download SDK`を押下します。

ダウンロード先を`~\src\flutter\`にします。

ダウンロードが終わったら`Visual Studio Code`を終了します。

`Windows ターミナル`を起動します。

Flutter のバージョン番号が表示されれば成功です。

```
> flutter –-version
Flutter 3.29.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision ea121f8859 (9 days ago) • 2025-04-11 19:10:07 +0000
Engine • revision cf56914b32
Tools • Dart 3.7.2 • DevTools 2.42.3
```

Flutter のバージョンを管理するためのアプリケーション`fvm`をインストールします。

```
> dart pub global activate fvm
```

Flutter の最新バージョンを確認します。

```
% fvm releases
```

Flutter の最新バージョンをインストールします。

```
% fvm install <最新バージョン番号>
% fvm global <最新バージョン番号>
```

Flutter に必要な環境が整っているかどうかを確認します。

```
% flutter doctor
```

ライセンスを確認して同意します。

```
% flutter doctor --android-licenses
```
