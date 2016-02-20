#!/usr/bin/env bash
set -e

FILES=test/*.lua
for f in $FILES
do
    echo "Running $f..."
    th $f
done
