#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Invalid number of arguments."
  exit 1
fi

cd `dirname $0`

owner=fukamachi
if [ "$GITHUB_REPOSITORY" ]; then
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

tagname="$owner/sbcl:$version-$target"

echo "Build $tagname"
docker build -t $tagname \
  --build-arg ROSWELL_IMAGE="$owner/roswell" \
  --build-arg ROSWELL_VERSION=$roswell_version \
  --build-arg PLATFORM=$target \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VCS_REF=`git rev-parse --short HEAD` \
  --build-arg VERSION="$version" \
  .

echo "Create alias tags"
if [ "$target" == "debian" ]; then
  docker tag $tagname "$owner/$image:$version"
fi

latest_version=$(basename $(cat versions | sort -Vr | head -n 1))
if [ "$latest_version" == "$version" ]; then
  docker tag $tagname "$owner/$image:latest-$target"
  if [ "$target" == "debian" ]; then
    docker tag $tagname "$owner/$image:latest"
  fi
fi
