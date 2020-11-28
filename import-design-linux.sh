#!/bin/bash

r=tmp/zelda-design4.0

git clone git@github.com:f-scratch/zelda-design4.0.git $r

[ -d app/assets/fonts ] && rm -rf app/assets/fonts
cp -TRv "${r}/app/assets/fonts" app/assets/fonts

[ -d app/assets/images ] && rm -rf app/assets/images
cp -TRv "${r}/app/assets/images" app/assets/images

[ -d app/assets/stylesheets/components ] && rm -rf app/assets/stylesheets/components
[ -d app/assets/stylesheets/vue-croppie ] && rm -rf app/assets/stylesheets/vue-croppie
[ -d app/assets/stylesheets/vue-flatpickr ] && rm -rf app/assets/stylesheets/vue-flatpickr
cp -TRv "${r}/app/assets/stylesheets" app/assets/stylesheets

rm app/assets/stylesheets/application.scss

for file in app/assets/stylesheets/*.scss ; do
  [[ $file == app/assets/stylesheets/_variables.scss ]] && continue
  [[ $file == app/assets/stylesheets/vue_application.scss ]] && continue

  if [[ ! "$(cat $file)" =~ "@import \"variables\"" ]]; then
    sed -i -e '1i\@import "variables";' $file
  fi

  if [[ $file == app/assets/stylesheets/common.scss ]]; then
    if [[ ! "$(cat $file)" =~ "\$black: #000 !default;" ]]; then
      sed -i -e '1i\$black: #000 !default;' $file
    fi
  fi
done

d=app/assets/stylesheets/pages

rm -rf $d

mkdir -p $d

f="${d}/index.scss"

[ -e $f ] && rm $f
touch $f

for p in "${@:1}"
do
  pf="${r}/${d}/${p}.scss"

  if [ -e $pf ]; then
    cp $pf app/assets/stylesheets/pages/
    echo "%${p}-import { @import \"${p}.scss\"; }" >> $f
    echo ".${p}-page { @extend %${p}-import; }" >> $f
  fi
done

[ -d app/javascript/src/assets/images ] && rm -rf app/javascript/src/assets/images
cp -TRv "${r}/app/javascript/src/assets/images" app/javascript/src/assets/images

mkdir -p app/javascript/src/assets/stylesheets/

[ -d app/javascript/src/assets/stylesheets/components ] && rm -rf app/javascript/src/assets/stylesheets/components
cp -TRv "${r}/app/javascript/src/assets/stylesheets" app/javascript/src/assets/stylesheets

[ -d app/javascript/src/locales_design ] && rm -rf app/javascript/src/locales_design
cp -TRv "${r}/app/javascript/src/locales/" app/javascript/src/locales_design

d=app/javascript/src/assets/stylesheets/pages

rm -rf $d

mkdir -p $d

f="${d}/index.scss"

[ -e $f ] && rm $f
touch $f

echo "@import \"home\";" >> $f

cp "${r}/${d}/home.scss" "${d}/home.scss"

for p in "${@:1}"
do
  pf="${r}/${d}/${p}.scss"

  if [ -e $pf ]; then
    cp $pf $d
    echo "@import \"${p}\";" >> $f
  fi
done

# for circleci
export DESIGN_LATEST_COMMIT_HASH=`git --git-dir="${r}/.git" log --pretty=format:"%h" -n 1`

rm -rf $r
