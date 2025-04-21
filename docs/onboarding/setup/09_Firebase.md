# Firebase

Dotto の Firebase プロジェクトに招待してもらうよう、Google アカウントのメールアドレスと併せて、メンバーに伝えます。

招待メールが届くので、メールの内容に従って、Dotto の Firebase プロジェクトに参加します。

## [macOS] Node.js をインストール

Node.js のバージョンを管理するためのアプリケーション`nvm`をインストールします。

```
% brew install nvm
% mkdir ~/.nvm
% echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
% echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm' >> ~/.zshrc
% echo '[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion' >> ~/.zshrc
```

Node.js の最新安定バージョンを確認します。  
以下の例では、v22.14.0 が最新安定バージョンです。

```
% nvm ls-remote
...
        v22.9.0
       v22.10.0
       v22.11.0   (LTS: Jod)
       v22.12.0   (LTS: Jod)
       v22.13.0   (LTS: Jod)
->     v22.13.1   (LTS: Jod)
       v22.14.0   (Latest LTS: Jod)
        v23.0.0
        v23.1.0
        v23.2.0
        v23.3.0
        v23.4.0
        v23.5.0
        v23.6.0
        v23.6.1
        v23.7.0
        v23.8.0
        v23.9.0
       v23.10.0
       v23.11.0
```

```
% nvm install <最新安定バージョン番号>
```

以下のコマンドを実行する事で、各種バージョン番号が表示されれば成功です。

```
% node -v
% nvm current
% npm -v
```

## [Windows] Node.js をインストール

[Node.js のダウンロードページ](https://nodejs.org/en/download/)で、ダウンロードするためのスクリプトを入手します。

- Node.js のバージョンは、LTS で最も新しいバージョンを選択
- OS は Windows を選択

`Copy to clipboard`を押下します。

`Windows ターミナル`を起動します。

コピーしたスクリプトをペーストして実行します。

バージョン番号が表示されれば成功です。

## Firebase CLI をインストール

```
% npm install -g firebase-tools
```

[Windows] 以下のコマンドを実行します。

```
> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

以下のコマンドを実行して、Firebase CLI にログインします。

```
% firebase login
```

以下のコマンドを実行して、プロジェクト`dotto`が表示されれば成功です。

```
% firebase projects:list
```
