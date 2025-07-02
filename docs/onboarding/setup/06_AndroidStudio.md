# Android Studio

Android Studio のセットアップは、Windows では必須、macOS では任意です。

## [JetBrains Toolbox](https://www.jetbrains.com/ja-jp/toolbox-app/)をインストール

Android Studio をダウンロード・インストールするためのアプリケーションです。

## Android Studio をインストール

JetBrains Toolbox から、Android Studio の最新安定版をダウンロードしてインストールします。

## Android Studio をセットアップ

- More Actions → SDK Manager → SDK Tools タブ → Android SDK Command-Line Tools (Latest) をチェック → Apply
- Plugins → Flutter インストール
- [Windows] More Actions → Virtual Device Maneger → Emulator 作成
  - 新しいデバイスを選択
  - Show Advanced Settings から Internal storage を 2048MB から 4096MB くらいにしておくことをおすすめ(2GB→4GB)
- Emulator を起動
  - Emulator の設定 (右側の 3 点ドット)から位置情報を変更
    - 日本国内にあれば OK
  - Android の言語を日本語に変更
  - Google Maps を開く
    - 現在地ボタンを押す
      - 位置情報を無理やり取得させる事でタイムゾーンが日本になる
      - 手動でタイムゾーンを設定すると設定が消えることがある
- Emulator を終了する
