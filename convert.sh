#!/bin/bash

mkdir -p target/assets
cp assets/* target/assets

./convertIndices.pl

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
