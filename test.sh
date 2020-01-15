#!/bin/bash

if [ $# <= 4 ]; then
  echo "Too few arguments."
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
cmd=${4:-$1}

tagname="$owner/$image:$version-$target"

echo "Test $tagname"
docker run --rm $tagname $cmd --version
