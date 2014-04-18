#!/usr/bin/env bash
set -o xtrace

git clone https://github.com/donny-dont/Pixelate-Flat.git ../pixelate-flat
pub get

# TODO: dartanalyzer on all libraries and main entry points in Pixelate 

docgen --compile --package-root=./packages --no-include-sdk --include-private lib/*.dart

rm dartdoc-viewer/client/out/web/packages
rm dartdoc-viewer/client/out/web/docs/packages
rm dartdoc-viewer/client/out/web/docs/Pixelate/packages

rm dartdoc-viewer/client/out/web/static/packages
rm dartdoc-viewer/client/out/web/static/js/packages
rm dartdoc-viewer/client/out/web/static/css/packages

mv dartdoc-viewer/client/out/packages dartdoc-viewer/client/out/web/packages
mv dartdoc-viewer/client/out/web ./.docs_staging

# TODO: run pub build web.. This will transform Pixelate and proper packages folder
pub build web 

# TODO: stage web
cp -r build/web .web_staging

# fetch origin
git fetch origin

# get branches 
git branch -v -a

# delete any files that might still be around.
rm -rf *

# copy docs up to github gh-pages branch
git checkout --track -b gh-pages origin/gh-pages

# delete any files that might still be around.
rm -rf *
date > date.txt
# TODO: unstage .web_staging
mv .web_staging web
# TODO: At this point Pixelate might want to just `mv .docs_staging web/docs`
mv .docs_staging web/docs
# 
#cd .docs_staging
#cp -r . ..
#cd ../
rm -rf .docs_staging
rm -rf .web_staging
git add -A
git commit -m"auto commit from drone"
git remote set-url origin git@github.com:donny-dont/Pixelate.git
git push origin gh-pages
