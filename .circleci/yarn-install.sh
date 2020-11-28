#!/bin/bash

# 秘匿情報を含むのでコマンドを出力しない
set -e

if ! [[ $(cat package.json | grep fs-designpack) =~ $BUNDLE_GITHUB__COM ]]
then
  # private リポジトリの node モジュールは Oauth の URL に置き換える
  # fs-designpack4.0
  designpackpkg=$(cat package.json | grep fs-designpack | sed -e "s/^.*\(git+ssh:\/\/\).*\(#.*\)\",\?$/git+https:\/\/${BUNDLE_GITHUB__COM}@github\.com\/f-scratch\/fs-designpack4\.0\.git\2/")

  # fs-wspack
  wspackpkg=$(cat package.json | grep fs-wspack | sed -e "s/^.*\(git+ssh:\/\/\).*\(#.*\)\",\?$/git+https:\/\/${BUNDLE_GITHUB__COM}@github\.com\/f-scratch\/fs-wspack\.git\2/")

  yarn remove fs-designpack fs-wspack

  yarn add $designpackpkg $wspackpkg
fi

[[ $(cat package.json | grep cypress) ]] && yarn remove cypress
yarn
