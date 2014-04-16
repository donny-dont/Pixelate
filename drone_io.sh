
git clone https://github.com/donny-dont/Pixelate-Flat.git ../pixelate-flat
pub install

docgen --compile --package-root=./packages --no-include-sdk --include-private lib/*.dart

rm dartdoc-viewer/client/out/web/packages
rm dartdoc-viewer/client/out/web/docs/packages
rm dartdoc-viewer/client/out/web/docs/Pixelate/packages

rm dartdoc-viewer/client/out/web/static/packages
rm dartdoc-viewer/client/out/web/static/js/packages
rm dartdoc-viewer/client/out/web/static/css/packages

mv dartdoc-viewer/client/out/packages dartdoc-viewer/client/out/web/packages
mv dartdoc-viewer/client/out/web ./.docs_staging

# fetch origin
git fetch origin

# get branches 
git branch -v -a

# delete any files that might still be around.
rm -rf *

# copy docs up to github gh-pages branch
#git checkout gh-pages
git checkout --track -b gh-pages origin/gh-pages

# delete any files that might still be around.
rm -rf *
date > date.txt
cd .docs_staging
cp -r . ..
cd ../
rm -rf .docs_staging
git add -A
git commit -m"auto commit from drone"
git remote set-url origin git@github.com:donny-dont/Pixelate.git
git push origin gh-pages
