# GitHub アカウント

## アカウント作成

[Sign up to GitHub](https://github.com/signup) から GitHub アカウントを作成します。

### 注意事項

- GitHub アカウントは 1 人 1 アカウントが原則です。1 人が複数のアカウント (個人用と学校用・会社用など) を作る必要はありません。
- 以上の原則から、`Email` には、個人のメインメールアドレスを設定することをおすすめします。
- `Username` は、できるだけ短く、アルファベットの大文字を含まないことをおすすめします。

## GitHub プロフィールの設定

[設定ページ](https://github.com/settings/profile)を開いて、`Name` と `Profile picture` が正しく設定されているかを確認してください。  
チームメンバーが、あなたのアカウントであることを認識するために、とても重要です。  
`Name` にはフルネームを `Given Family` の形式で入力します。

## [任意] [GitHub Education](https://github.com/education) への登録

GitHub Copilot などの GitHub Pro ユーザ向けのサービスを無料で利用することができるほか、さまざまなサービスのクレジットを無料でもらえるなどの特典を得ることができます。

## Dotto への招待を承諾

既存メンバーに、自分の `Username` を伝えて、Dotto に招待してもらうようにお願いしてください。  
招待されると招待メールが届きます。  
リンクを開いて、招待を承諾してください。

[メンバ一覧](https://github.com/orgs/fun-dotto/people?query=role%3Amember)で自分のユーザ名を検索して、ヒットすれば完了です。

# Git

## [Windows] Git をインストール

```pwsh
winget install --id Git.Git -e --source winget
```

## Git をセットアップ

[macOS] ターミナル.app を起動します。

[Windows] Windows ターミナルを起動します。

以下のコマンドを実行します。
(<>内は自分で入力して下さい)

```zsh
git config --global user.name "<自分の名前: フルネームを `Given Family` の形式で>"
```

```zsh
git config --global user.email "<メールアドレス: GitHubで登録したものと同一のもの>"
```

## GitHub の SSH を設定

### 秘密鍵と公開鍵を生成

```zsh
mkdir ~/.ssh
```

```zsh
ssh-keygen -t ed25519 -f ~/.ssh/github -C "<メールアドレス>"
```

### [macOS] SSH Agent に秘密鍵を登録

```zsh
eval "$(ssh-agent -s)"
```

```zsh
echo "Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/github
" >> ~/.ssh/config
```

```zsh
ssh-add --apple-use-keychain ~/.ssh/github
```

### [Windows] SSH Agent に秘密鍵を登録

```pwsh
Get-Service -Name ssh-agent | Set-Service -StartupType Manual
Start-Service ssh-agent
```

```pwsh
ssh-add ~/.ssh/github
```

### GitHub に公開鍵を登録

[macOS] 公開鍵をクリップボードにコピーします。

```zsh
pbcopy < ~/.ssh/github.pub
```

[Windows] 公開鍵をクリップボードにコピーします。

```pwsh
cat ~/.ssh/github.pub | clip
```

[GitHub の SSH キー設定ページ](https://github.com/settings/keys)を開きます。

`New SSH key`を押下します。

`Title`には、コンピュータ名などの名前をつけます。

`Key`に、クリップボードにコピーした公開鍵をペーストします。

`Add SSH key`を押下します。

### 接続確認

以下のコマンドを実行して、表示されれば成功です。

```zsh
ssh -T git@github.com
```

```
Hi <username>! You've successfully authenticated, but GitHub does not provide shell access.
```
