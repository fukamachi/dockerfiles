#!/bin/bash

set -ex

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
build_args=$3
platform=${PLATFORM:-linux/amd64}

roswell_version=$(cat versions | grep "$version," | head -n 1 | awk -F, '{ print $2 }')

if [ "$roswell_version" == "" ]; then
  echo "Version not found: $version"
  exit 1
fi

echo "ROSWELL_VERSION=$roswell_version"

tagname="$owner/sbcl:$version-$target"

if [ $(echo "$version" | awk '{print substr($0,1,1);exit}') = "1" ]; then
  if [[ "$platform" = *"linux/arm64"* ]]; then
    echo "SBCL $version can't build on linux/arm64."
    platform=linux/amd64
  fi
fi

echo "Build $tagname"
eval docker buildx build -t $tagname \
  "$build_args" \
  --platform "$platform" \
  --build-arg ROSWELL_IMAGE="$owner/roswell" \
  --build-arg ROSWELL_VERSION=$roswell_version \
  --build-arg PLATFORM=$target \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VCS_REF=`git rev-parse --short HEAD` \
  --build-arg VERSION="$version" \
  .

docker pull "$tagname" >/dev/null 2>&1 || true

echo "Create alias tags"
if [ "$target" == "debian" ]; then
  docker pull "$tagname"
  docker tag "$tagname" "$owner/sbcl:$version"
  if [[ "$build_args" = *"--push"* ]]; then
    docker push "$owner/sbcl:$version"
  fi
fi

latest_version=$(basename $(cat versions | awk -F, '{ print $1 }' | sort -Vr | head -n 1))
if [ "$latest_version" == "$version" ]; then
  docker tag "$tagname" "$owner/sbcl:latest-$target"
  if [[ "$build_args" = *"--push"* ]]; then
    docker push "$owner/sbcl:latest-$target"
  fi
  if [ "$target" == "debian" ]; then
    docker tag "$tagname" "$owner/sbcl:latest"
    if [[ "$build_args" = *"--push"* ]]; then
      docker push "$owner/sbcl:latest"
    fi
  fi
fi
