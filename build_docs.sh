#!/usr/bin/env sh

set -x
set -e

DOCDIR=build/tl

mkdir -p ${DOCDIR}/docs
cp -r src .dokx *.txt *.md *.rockspec $DOCDIR

cd $DOCDIR
dokx-build-package-docs -o docs .
# turn off jekyll so we can use underscores in file names
touch .nojekyll
cd -
