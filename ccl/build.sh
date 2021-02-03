#!/bin/bash

set -eux

if [ $# -ne 2 ]; then
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

roswell_version=$(cat versions | grep "$version," | head -n 1 | awk -F, '{ print $2 }')

if [ "$roswell_version" == "" ]; then
  echo "Version not found: $version"
  exit 1
fi

echo "ROSWELL_VERSION=$roswell_version"

tagname="$owner/ccl:$version-$target"

echo "Build $tagname"
docker buildx build -t $tagname \
  --load \
  --build-arg ROSWELL_IMAGE="$owner/roswell" \
  --build-arg ROSWELL_VERSION=$roswell_version \
  --build-arg PLATFORM=$target \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VCS_REF=`git rev-parse --short HEAD` \
  --build-arg VERSION="$version" \
  .

echo "Create alias tags"
if [ "$target" == "debian" ]; then
  docker tag $tagname "$owner/ccl:$version"
fi

latest_version=$(basename $(cat versions | awk -F, '{ print $1 }' | sort -Vr | head -n 1))
if [ "$latest_version" == "$version" ]; then
  docker tag $tagname "$owner/ccl:latest-$target"
  if [ "$target" == "debian" ]; then
    docker tag $tagname "$owner/ccl:latest"
  fi
fi
