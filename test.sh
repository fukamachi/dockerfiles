#!/bin/bash

set -eux

if [ $# -ne 3 ]; then
  echo "Invalid number of arguments."
  exit 1
fi

cd `dirname $0`

owner=fukamachi
if [ -z ${GITHUB_REPOSITORY-x} ]; then
    owner="${GITHUB_REPOSITORY%/*}"
fi

image=$1
version=$2
os=$3

tagname="$owner/$image:$version-$os"

echo "Test $tagname"
docker run --rm "$tagname" --version
