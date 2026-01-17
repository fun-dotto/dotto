# Dotto

リポジトリをクローンします。

```zsh
git clone git@github.com:fun-dotto/dotto.git
```

```zsh
cd dotto
```

## プロジェクトをセットアップ

プロジェクトの依存関係のインストールをします。

```zsh
task install-all
```

Firebase の情報をセットアップします。

```zsh
dart pub global activate flutterfire_cli
```

```zsh
flutterfire configure
```

メンバーに`.env`ファイルをもらい、プロジェクト直下に配置します。

必要なコードを生成します。

```zsh
task build-all
```

## [macOS] iOS Simulator で起動する

`Simulator.app`を起動します。

以下のコマンドを実行します。

```zsh
task run
```

## [macOS] iOS 端末で起動する

Mac と iPhone を接続します。

メンバーに iOS Fastlane の`.env`ファイルをもらい、`ios/fastlane/`に配置します。

以下のコマンドを実行します。

```zsh
task match_development
```

```zsh
task run
```

## [macOS] Android Emulator で起動する

Visual Studio Code から Android エミュレータを起動します。

以下のコマンドを実行します。

```zsh
task run
```

q キーを押して、一度終了します。

以下のコマンドを実行して、証明書のフィンガープリントを取得します。

```zsh
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android
```

[Firebase](https://console.firebase.google.com/u/0/project/swift2023groupc/settings/general/android:jp.ac.fun.dotto?hl=ja)にアクセスして、表示された SHA-1 のフィンガープリントを登録する。

## [Windows] Android Emulator で起動する

Android Studio で使用されている Java があるフォルダのパスをコピーする。

Ex. `C:\Program Files\Android\Android Studio\jbr\bin`

```pwsh
set PATH=<コピーしたパスをペースト>;%PATH%
```

以下のコマンドを実行します。

```pwsh
task run
```

q キーを押して、一度終了します。

以下のコマンドを実行して、証明書のフィンガープリントを取得します。

```pwsh
keytool -list -v -alias androiddebugkey -keystore $env:USERPROFILE\.android\debug.keystore -storepass android
```

[Firebase](https://console.firebase.google.com/u/0/project/swift2023groupc/settings/general/android:jp.ac.fun.dotto?hl=ja)にアクセスして、表示された SHA-1 のフィンガープリントを登録する。

## Google アカウントでログイン

Dotto アプリに Google アカウントでログインします。

正常にログインできれば、オンボーディング完了です。

おつかれさまでした。
