#!/bin/bash

set -e # Exit with nonzero exit code if anything fails

mkdir -p target/assets
cp assets/* target/assets

./convertIndices.pl

cd sources/www.cs.utexas.edu/\~EWD/transcriptions

for i in EWD*; do
  cd $i
  for f in *.htm*; do
    TARGET="../../../../../target/$f"
    mkdir -p `dirname $TARGET`
    cat $f | iconv -c --from UTF-8 --to UTF-8 | ../../../../../convertArticle.pl > $TARGET
  done
  cd ..
done
