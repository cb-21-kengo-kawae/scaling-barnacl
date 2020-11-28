#!/bin/bash
set -ex

_content_name=${CIRCLE_PROJECT_REPONAME#*-}
log_dir=log/webtest
log_path=$log_dir/logging.log

rm -rf $log_dir
mkdir -p $log_dir

ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY RAILS_ENV=production SECRET_KEY_BASE=$SECRET_KEY_BASE LOG_PATH=$log_path bundle exec unicorn_rails -c config/unicorn.rb -E production -D && \
echo -e "GET /${_content_name}/app/healthcheck HTTP/1.0\r\n" | socat stdio $HOME/target/tmp/sockets/unicorn.sock|grep -q "200 OK" && \
echo -e "GET /${_content_name}/app/databasecheck HTTP/1.0\r\n" | socat stdio $HOME/target/tmp/sockets/unicorn.sock|grep -q "204 No Content" && : \
|| (cat $log_path log/unicorn.stderr.log log/unicorn.stdout.log && exit 1)
