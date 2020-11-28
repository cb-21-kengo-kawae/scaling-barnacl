#!/bin/bash
set -ex

git reset
git checkout .
git fetch
git checkout $SOURCE_BRANCH

remote_commit=$(git rev-parse origin/${SOURCE_BRANCH})
local_commit=$(git rev-parse HEAD)

if [ ! $remote_commit = $local_commit ]; then
  git pull origin $SOURCE_BRANCH
  rm -rf public/assets
fi

sed -i -e "s/config\.cache_classes = false/config\.cache_classes = true/g" config/environments/development.rb
sed -i -e "s/config\.eager_load = false/config\.eager_load = true/g" config/environments/development.rb

[[ $(cat Gemfile.lock | grep -A 1 "BUNDLED WITH") =~ ([0-9.]*)$  ]]

bundler_v="${BASH_REMATCH[1]}"
bundler_v_arg="_${bundler_v}_"

gem install bundler -v "${bundler_v}"

bundle config --global build.nokogiri --use-system-libraries

bundle "${bundler_v_arg}" check || bundle "${bundler_v_arg}" install

printf "%s" "waiting for zelda-app-db ..."
while ! ping -c 1 -n -w 1 zelda-app-db -p 3306 &> /dev/null
do
    printf "%c" "."
done
printf "\n%s\n"  "find zelda-app-db"

bundle exec rails db:create
bundle exec rails log:clear tmp:clear
bundle exec rails ridgepole:apply

[ ! -d public/assets] && bundle exec rails assets:precompile assets:clean

pid_file=tmp/pids/server.pid
[ -e $pid_file ] && rm $pid_file

caching_dev=tmp/caching-dev.txt
[ ! -e $caching_dev ] && touch $caching_dev

PORT=80 bundle exec rails s -b 0.0.0.0 -p 80
