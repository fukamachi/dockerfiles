#!/bin/bash

if [ $# -ne 3 ]; then
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

tagname="$owner/$image:$version-$target"

echo "Build $tagname"
docker build -t $tagname \
    --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    --build-arg VERSION="$version" \
    $image/$target/
