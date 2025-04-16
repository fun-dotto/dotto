# [Windows] Windows Terminal をインストール

[Microsoft Store](https://apps.microsoft.com/detail/9n0dx20hk701?hl=ja-JP&gl=JP)からインストールします。

## PowerShell をアップデート

シェルは、Powershell を使用します。デフォルトでインストールされている Powershell は最新版でないため、アップデートします。

既存の PowerShell をアンインストールします。

```
$ winget uninstall PowerShell
'msstore' ソースでは、使用する前に次の契約を表示する必要があります。
Terms of Transaction: https://aka.ms/microsoft-store-terms-of-transaction
ソースが正常に機能するには、現在のマシンの 2 文字の地理的リージョンをバックエンド サービスに送信する必要があります (例: "US")。

すべてのソース契約条件に同意しますか?
[Y] はい  [N] いいえ: y
見つかりました PowerShell [9MZ1SNWT0N5D]
パッケージのアンインストールを開始しています...
正常にアンインストールされました
```

新規 PowerShell をインストールします。

```
$ winget install --id Microsoft.Powershell --source winget
見つかりました PowerShell [Microsoft.PowerShell] バージョン 7.3.3.0
このアプリケーションは所有者からライセンス供与されます。
Microsoft はサードパーティのパッケージに対して責任を負わず、ライセンスも付与しません。
ダウンロード中 https://github.com/PowerShell/PowerShell/releases/download/v7.3.3/PowerShell-7.3.3-win-x64.msi
  ██████████████████████████████   101 MB /  101 MB
インストーラーハッシュが正常に検証されました
パッケージのインストールを開始しています...
インストールが完了しました
```
