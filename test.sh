#!/bin/bash

set -eux

if [ $# -ne 3 ]; then
  echo "Invalid number of arguments."
  exit 1
fi

cd `dirname $0`

owner=fukamachi
if [ "$GITHUB_REPOSITORY" ]; then
    owner="${GITHUB_REPOSITORY%/*}"
fi

image=$1
version=$2
target=$3

tagname="$owner/$image:$version-$target"

echo "Test $tagname"
docker run --rm $tagname --version
