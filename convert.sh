#!/bin/bash

set -e # Exit with nonzero exit code if anything fails

mkdir -p target/assets
cp assets/* target/assets

# https://github.com/travis-ci/apt-package-whitelist/issues/3284
# ./convertIndices.pl

cd sources/www.cs.utexas.edu/\~EWD/transcriptions

for i in EWD*; do
  cd $i
  for f in *.html; do
    TARGET="../../../../../target/$f"
    mkdir -p `dirname $TARGET`
    ../../../../../convertArticle.pl < $f > $TARGET
  done
  cd ..
done
