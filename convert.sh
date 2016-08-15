#!/bin/bash

set -e # Exit with nonzero exit code if anything fails

mkdir -p target/assets
cp -r assets/* target/assets

./convertIndices.pl

./convertArticles.pl
