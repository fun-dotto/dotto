# Dotto

リポジトリをクローンします。

```
% git clone git@github.com:fun-dotto/dotto.git
% cd dotto
```

## プロジェクトをセットアップ

プロジェクトの依存関係のインストールをします。

```
% make install
```

Firebase の情報をセットアップします。

```
% dart pub global activate flutterfire_cli
% flutterfire configure
```

メンバーに`.env.dev`ファイルをもらい、プロジェクト直下に配置します。

必要なコードを生成します。

```
% make build
```

## [macOS] iOS Simulator で起動する

`Simulator.app`を起動します。

以下のコマンドを実行します。

```
% make run
```

## [macOS] Android Emulator で起動する

以下のコマンドを実行すると、証明書のフィンガープリントが表示される。

```
% keytool -genkey -v -alias dotto -keyalg RSA -keysize 2048 -validity 365 -keypass dottoandroid -keystore ~/.android/debug.keystore -storepass android
% keytool -list -v -alias dotto -keystore ~/.android/debug.keystore -storepass android
```

[Firebase](https://console.firebase.google.com/u/0/project/swift2023groupc/settings/general/android:jp.ac.fun.dotto?hl=ja)にアクセスして、表示された SHA-1 のフィンガープリントを登録する。

Visual Studio Code を開いて、`android/key.properties`を作成し、以下の内容を記述する。

```
keyAlias=dotto
keyPassword=dottoandroid
storeFile=~/.android/debug.keystore
storePassword=android
```

## [Windows] Android Emulator で起動する

Android Studio で使用されている Java があるフォルダのパスをコピーする。

Ex. `C:\Program Files\Android\Android Studio\jbr\bin`

```
> set PATH=<コピーしたパスをペースト>;%PATH%
```

以下のコマンドを実行すると、証明書のフィンガープリントが表示される。

```
> keytool -genkey -v -alias dotto -keyalg RSA -keysize 2048 -validity 365 -keypass dottoandroid -keystore ~\.android\debug.keystore -storepass android
> keytool -list -v -alias dotto -keystore ~\.android\debug.keystore -storepass android
```

[Firebase](https://console.firebase.google.com/u/0/project/swift2023groupc/settings/general/android:jp.ac.fun.dotto?hl=ja)にアクセスして、表示された SHA-1 のフィンガープリントを登録する。

Visual Studio Code を開いて、`.\android\key.properties`を作成し、以下の内容を記述する。

```
keyAlias=dotto
keyPassword=dottoandroid
storeFile=~\.android\debug.keystore
storePassword=android
```
