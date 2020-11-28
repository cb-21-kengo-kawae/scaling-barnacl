# ZeldaTemplate4th

## zelda-template4thとは
- 本リポジトリは、b→dash4.0の画面系サービスのためのテンプレートプロジェクトです
- `zelda-xxxx4th`といった新規サービスを開発する場合、本リポジトリをベースにコピーして作成することで、立ち上げのコストを削減することができます

## 利用方法

### Use this templateボタン : 管理者のみ
- `Use this template`ボタンをクリック
- この操作はgithubの管理者のみ行えるため、依頼します

![screenshot-github com-2020 09 19-12_34_28](https://user-images.githubusercontent.com/61486046/93658218-9b7c8200-fa74-11ea-9add-a1ec6f63a330.png)

### リネーム処理
- 新規サービスが `zelda-sampleapp4th` とした場合、下記のリネームを行う
- `ZeldaTemplate4th` → `ZeldaSampleapp4th`
- `template4th` → `sampleapp4th`

### ライブラリのインストール

```
$ bundle
```

```
$ yarn install
```

### docker環境構築

```
$ docker-compose up
```

- donkey-authの`oauth_applications`に下記のレコードを追加

```sql
INSERT INTO `oauth_applications` (`name`, `uid`, `secret`, `redirect_uri`, `scopes`, `created_at`, `updated_at`, `internal`, `after_sign_out_uri`)
VALUES
	('appsample4th', 'appsample4th_uid', 'appsample4th_secret', 'http://localhost/appsample4th/auth/callback', 'pla_pri pla_pub rep_pri rep_pub sfa_pri sfa_pub cam_pri cam_pub cms_pri cms_pub userinfo', '2020-09-19 00:00:00', '2020-09-19 00:00:00', 1, NULL);
```

### DB作成とmigration

```
$ bundle exec rake db:create
```

```
$ bundle exec rake ridgepole:apply
```

```
$ bundle exec rake account_record:provision[1,1,1]
```

### デザイン取り込みのCI設定

デザイン取り込みをCIで行いたい場合は、以下を実施してください

- `.circleci/update-design.sh`の`APP_NAME`に取り込む必要があるアプリを記載してください
  - [こちら](https://github.com/f-scratch/zelda-design4.0/tree/develop/app/javascript/src/assets/stylesheets/pages)から必要なものを選択します
- `.circleci/config.yml`の`scheduled-workflow`をコメントインしてください
  - これによりCI定期実行によるデザイン取り込みのPull Requestが作成されます
