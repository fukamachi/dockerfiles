#!/bin/bash

set -ex

PLATFORM=linux/amd64
build_arg=""
if [ "$GITHUB_REF" = "refs/heads/master" ]; then
  build_arg="--push"
  PLATFORM=linux/amd64,linux/arm64
fi

if [[ $# -eq 0 ]]; then
  echo "Invalid arguments."
  exit 1
fi

target=$1; shift

versions="$@"
if [[ $# -eq 0 ]]; then
  versions=`cat sbcl/versions | awk -F, '{ print $1 }'`
fi

for version in $versions
do
  PLATFORM=${PLATFORM} ./build.sh sbcl $version $target $build_arg
done
