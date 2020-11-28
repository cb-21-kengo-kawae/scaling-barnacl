#!/bin/bash

set -ex

_content_name=${CIRCLE_PROJECT_REPONAME#*-}

if [ "$CIRCLE_BRANCH" == "release-prd" ]; then
  export RAILS_ENV=production
  export S3_BUCKET="cdn-assets-bdash-cloud-com"

  bundle exec rake assets:clobber assets:precompile
  aws s3 sync public/assets s3://$S3_BUCKET/${_content_name}/assets --profile ${CIRCLE_BRANCH}
  aws s3 cp public/assets/.sprockets-manifest-*.json\
    s3://$S3_BUCKET/${_content_name}-$RAILS_ENV-manifests/ --profile ${CIRCLE_BRANCH}
  rm -rf public/assets/*
  aws s3 sync ./public/packs s3://$S3_BUCKET/${_content_name}/packs --profile ${CIRCLE_BRANCH}
  ls -d ./public/packs/* | cut -d' ' -f 9 | grep -vE 'manifest.json$' | xargs rm -rf
else
  export RAILS_ENV=staging
  export S3_BUCKET="cdn-assets-bdash-cloud-xyz"

  bundle exec rake assets:clobber assets:precompile
  aws s3 sync public/assets s3://$S3_BUCKET/${_content_name}/assets
  aws s3 cp public/assets/.sprockets-manifest-*.json\
    s3://$S3_BUCKET/${_content_name}-$RAILS_ENV-manifests/
  rm -rf public/assets/*
  aws s3 sync ./public/packs s3://$S3_BUCKET/${_content_name}/packs
  ls -d ./public/packs/* | cut -d' ' -f 9 | grep -vE 'manifest.json$' | xargs rm -rf
fi
