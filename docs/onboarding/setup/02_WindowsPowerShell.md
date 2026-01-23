# [Windows] PowerShell をアップデート

`Windows ターミナル` (英: `Windows Terminal`) を起動します。

インストールされていない場合は、[Microsoft Store](https://apps.microsoft.com/detail/9n0dx20hk701?hl=ja-JP&gl=JP) からインストールします。

Windows ターミナルでは、Powershell を使用します。デフォルトでインストールされている Powershell は最新版でないため、アップデートします。

既存の PowerShell をアンインストールします。

```pwsh
winget uninstall PowerShell
```

新規 PowerShell をインストールします。

```pwsh
winget install --id Microsoft.Powershell --source winget
```
