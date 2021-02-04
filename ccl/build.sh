#!/bin/bash

set -ex

if [[ $# > 3 ]]; then
  echo "Invalid number of arguments."
  exit 1
fi

cd `dirname $0`

owner=fukamachi
if [ -z ${GITHUB_REPOSITORY-x} ]; then
    owner="${GITHUB_REPOSITORY%/*}"
fi

version=$1
target=$2
build_args=$3
# NOTE: CCL ignores $PLATFORM
platform=linux/amd64

roswell_version=$(cat versions | grep "$version," | head -n 1 | awk -F, '{ print $2 }')

if [ "$roswell_version" == "" ]; then
  echo "Version not found: $version"
  exit 1
fi

echo "ROSWELL_VERSION=$roswell_version"

tagname="$owner/ccl:$version-$target"

tag_options="-t $tagname"
if [ "$target" == "debian" ]; then
  tag_options="$tag_options -t $owner/ccl:$version"
fi
latest_version=$(basename $(cat versions | awk -F, '{ print $1 }' | sort -Vr | head -n 1))
if [ "$latest_version" == "$version" ]; then
  tag_options="$tag_options -t $owner/ccl:latest-$target"
  if [ "$target" == "debian" ]; then
    tag_options="$tag_options -t $owner/ccl:latest"
  fi
fi

echo "Build $tagname"
eval docker buildx build $tag_options \
  $build_args \
  --platform "$platform" \
  --build-arg ROSWELL_IMAGE="$owner/roswell" \
  --build-arg ROSWELL_VERSION=$roswell_version \
  --build-arg PLATFORM=$target \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VCS_REF=`git rev-parse --short HEAD` \
  --build-arg VERSION="$version" \
  .
