# dotenvxとpre-commitのセットアップ

mise経由でdotenvxとpre-commitをインストールする

```
task install-all
```

環境変数を追加したいときは以下を実行
```
dotenvx set KEY "value" -f [環境変数ファイルパス]
```

平文を見たいときは以下を実行
```
dotenvx decrypt --stdout -f [環境変数ファイルパス] > .env.decrypted
```
