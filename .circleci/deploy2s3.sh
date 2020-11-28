#!/bin/bash
set -ex

_content_name=${CIRCLE_PROJECT_REPONAME#*-}
_deploy_filename="$(echo $CIRCLE_SHA1 | cut -c -7)-${_content_name}.tgz"

find tmp -type f | xargs rm -rvf
chmod -R g+w .
tar -zcf /tmp/${_deploy_filename} --exclude="./vendor/circleci" .

if [ "$CIRCLE_BRANCH" == "release-prd" ]; then
	aws s3 cp /tmp/${_deploy_filename} s3://circleci-bdash-prd/${_content_name}/${_deploy_filename} --profile ${CIRCLE_BRANCH}
else
	aws s3 cp /tmp/${_deploy_filename} s3://circleci-bdash/${_content_name}/${_deploy_filename}
fi
