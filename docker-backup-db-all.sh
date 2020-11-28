#!/bin/bash
set -e

printf '\e[91m%s\n%s\e[0m\n' \
    "このコマンドはDBのバックアップを更新するコマンドです。" \
    "更新後内容をコミットした場合、全ての開発者に影響を与えます。"
read -p "本当に実行しますか？ (Y/n) : "

if [[ $REPLY == 'Y' ]] ; then
  set -ex

  mysqldump -h 127.0.0.1 -u root -ptest -x --all-databases > docker/db-backups/db-all.sql
  zip docker/db-all.sql.zip docker/db-backups/db-all.sql
  md5 docker/db-backups/db-all.sql > docker/db-checksum.txt
fi
