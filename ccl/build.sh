#!/bin/bash

set -ex

usage() {
  echo "Usage: ccl/build.sh <version> <os>"
  echo ""
  echo "Environment variables:"
  echo "  BUILD_ARGS"
}

if [[ $# > 2 ]]; then
  echo "Error: Invalid number of arguments."
  exit 1
fi

cd `dirname $0`

owner=fukamachi
if [ -z ${GITHUB_REPOSITORY-x} ]; then
    owner="${GITHUB_REPOSITORY%/*}"
fi

version=${1:-latest}
os=${2:-debian}
build_args=${BUILD_ARGS:---load}

if [ "$version" == "latest" ]; then
  version=$(cat versions | sort -n | tail -n 1 | awk -F, '{ print $1 }')
fi

roswell_version=$(cat versions | grep "$version," | head -n 1 | awk -F, '{ print $2 }')

if [ "$roswell_version" == "" ]; then
  echo "Error: Version not found: $version"
  exit 1
fi

echo "ROSWELL_VERSION=$roswell_version"

tagname="$owner/ccl:$version-$os"

tag_options="-t $tagname"
if [ "$os" == "debian" ]; then
  tag_options="$tag_options -t $owner/ccl:$version"
fi
latest_version=$(basename $(cat versions | awk -F, '{ print $1 }' | sort -Vr | head -n 1))
if [ "$latest_version" == "$version" ]; then
  tag_options="$tag_options -t $owner/ccl:latest-$os"
  if [ "$os" == "debian" ]; then
    tag_options="$tag_options -t $owner/ccl:latest"
  fi
fi

echo "Build $tagname"
eval docker buildx build $tag_options \
  $build_args \
  --platform "linux/amd64" \
  --build-arg ROSWELL_IMAGE="$owner/roswell" \
  --build-arg ROSWELL_VERSION=$roswell_version \
  --build-arg OS=$os \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VCS_REF=`git rev-parse --short HEAD` \
  --build-arg VERSION="$version" \
  .
