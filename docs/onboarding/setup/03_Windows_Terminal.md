# [Windows] Windows ターミナル

## Windows ターミナル をインストール

[Microsoft Store](https://apps.microsoft.com/detail/9n0dx20hk701?hl=ja-JP&gl=JP) からインストールします。

## PowerShell をアップデート

Windows ターミナルでは、Powershell を使用します。デフォルトでインストールされている Powershell は最新版でないため、アップデートします。

既存の PowerShell をアンインストールします。

```
$ winget uninstall PowerShell
```

新規 PowerShell をインストールします。

```
$ winget install --id Microsoft.Powershell --source winget
```
