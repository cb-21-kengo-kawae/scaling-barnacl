#!/bin/bash

set -ex

# ページごとのCSSを取り込むため、アプリごとに変更が必要
APP_NAME=(home settings)

DATETIME=`date +%Y%m%d-%H%M%S`
PR_BRANCH="update/design-$DATETIME"
COMMIT_MSG="feat: design update from zelda-design4.0 as of $DATETIME"
PR_TEMPLATE=$HOME/target/.github/CIRCLECI_PULL_REQUEST_TEMPLATE.md
DESIGN_REPO=zelda-design4.0
BASE_BRANCH=develop

# set up git config
git config --global user.email "$GITHUB_USER_EMAIL"
git config --global user.name "circleci"

# import design
source ./import-design-linux.sh $APP_NAME

DIFF_FILES=`git diff --name-only`

if [ ${#DIFF_FILES[@]} -ne 0 ]; then
  # commit changed
  git checkout -b $PR_BRANCH
  git add . && git commit -m "$COMMIT_MSG"

  # create pull request via hub
  sed -ie "s/__DATETIME__$/$DATETIME/" $PR_TEMPLATE
  echo -e "\nhttps://github.com/$CIRCLE_PROJECT_USERNAME/$DESIGN_REPO/commit/$DESIGN_LATEST_COMMIT_HASH" >> $PR_TEMPLATE
  hub pull-request -F $PR_TEMPLATE -b $BASE_BRANCH -p
fi
