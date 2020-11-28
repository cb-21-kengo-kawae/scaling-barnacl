#!/bin/bash

set -ex

# bundlerのUpdate
sudo gem update bundler
bundle config --local path $BUNDLE_PATH

# api
bundle exec yard doc -m markdown
bundle exec yard graph --full -f yard-graph.dot
dot -Tpng yard-graph.dot -o doc/yard-graph.png
aws s3 cp doc s3://bdash2-docs/mc/${CIRCLE_PROJECT_REPONAME}/${CIRCLE_BRANCH}/api --recursive

# db
mv config/database.ci.yml config/database.yml
bundle exec rake db:create --trace
bundle exec rake ridgepole:apply
bundle exec erd
aws s3 cp erd.pdf s3://bdash2-docs/mc/${CIRCLE_PROJECT_REPONAME}/${CIRCLE_BRANCH}/db_structure/
