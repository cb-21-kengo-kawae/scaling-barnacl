#!/bin/bash
set -ex

mv config/database.ci.yml config/database.yml
mv config/settings/test.ci.yml config/settings/test.yml

sudo gem update bundler

mysql -h $DB_HOST -u root -e "CREATE DATABASE IF NOT EXISTS circle_ruby_test_platform${CIRCLE_NODE_INDEX}; CREATE USER readonly; GRANT SELECT ON *.* TO readonly;"
bundle exec rake db:create --trace
bundle exec rspec --backtrace
