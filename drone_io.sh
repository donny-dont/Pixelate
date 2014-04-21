#!/usr/bin/env bash
set -o xtrace

git clone https://github.com/donny-dont/Pixelate-Flat.git ../pixelate-flat
pub get

# TODO: dartanalyzer on all libraries and main entry points in Pixelate 

# Get library files
L1=$(ls lib/*.dart) 
# Get component library files
L2=$(for r in $(ls -d lib/components/*) ; do echo ${r}/`basename $r`.dart; done)
# Join library files with component library files
R=$(for L in "${L1[@]}" "${L2[@]}" ; do echo "$L" ; done)
docgen --compile --package-root=./packages --no-include-sdk --include-private $R

rm dartdoc-viewer/client/out/web/packages
rm dartdoc-viewer/client/out/web/docs/packages
rm dartdoc-viewer/client/out/web/docs/Pixelate/packages

rm dartdoc-viewer/client/out/web/static/packages
rm dartdoc-viewer/client/out/web/static/js/packages
rm dartdoc-viewer/client/out/web/static/css/packages

# Stage doc files
mv dartdoc-viewer/client/out/packages dartdoc-viewer/client/out/web/packages
mv dartdoc-viewer/client/out/web ./.docs_staging

# TODO: run pub build web.. This will transform Pixelate and proper packages folder
pub build web

# Fix the paths in the built files
# TODO: Remove when https://code.google.com/p/dart/issues/detail?id=17596 is fixed
cd bin
dart --package-root=packages fix_paths.dart
cd ..

# Stage web files
cp -r build/web .web_staging

# Fetch origin
git fetch origin

# Get branches
git branch -v -a

# Delete any files that might still be around.
rm -rf *

# Copy docs up to GitHub gh-pages branch
git checkout --track -b gh-pages origin/gh-pages

# Delete any files that might still be around.
rm -rf *

# Unstage files
date > date.txt
cp -r .web_staging/* .
cp -r .docs_staging docs
rm -rf .docs_staging
rm -rf .web_staging

git add -A
git commit -m"auto commit from drone"
git remote set-url origin git@github.com:donny-dont/Pixelate.git
git push origin gh-pages
