#!/bin/bash
set -e

if [[ $(md5 docker/db-backups/db-all.sql) != $(cat docker/db-checksum.txt) ]] ; then
  printf '\e[91m%s\n%s\n%s\e[0m\n' "以下のコマンドで db-all.sql を更新してください。" \
    "unzip docker/db-all.sql.zip docker/db-backups/db-all.sql"
  exit 1
fi

mysql -h zelda-app-db -u root -ptest < docker/db-backups/db-all.sql
