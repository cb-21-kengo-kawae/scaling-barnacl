#!/bin/bash
set -ex

# npm run eslint-old
npm run eslint

ruby -v

# bundlerのUpdate
sudo gem update bundler
bundle config --local path $BUNDLE_PATH

bundle exec rake developments:tester:i18n_compare
bundle exec rubocop
bundle exec brakeman
