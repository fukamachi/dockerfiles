#!/bin/bash

set -eux

usage() {
  echo "Usage: sbcl/build.sh <version> <os>"
  echo ""
  echo "Environment variables:"
  echo "  ARCH, BUILD_ARGS"
}

if [[ $# > 2 ]]; then
  echo "Error: Invalid number of arguments."
  usage
  exit 1
fi

cd `dirname $0`

owner=fukamachi
if [ -z ${GITHUB_REPOSITORY-x} ]; then
    owner="${GITHUB_REPOSITORY%/*}"
fi

version=${1:-latest}
os=${2:-debian}

if [ -z ${BUILD_ARGS+x} ]; then
  build_args="--load"
else
  build_args=${BUILD_ARGS}
fi

if [ -z ${ARCH+x} ]; then
  machine_arch=$(uname -m)

  case "$machine_arch" in
    arm64|aarch64)
      arch="linux/$machine_arch"
      ;;
    x86_64|x86-64|amd64)
      arch="linux/amd64"
      ;;
    *)
      echo "Error: Unsupported architecture '$machine_arch'"
  esac
else
  arch=$ARCH
fi

if [ "$version" == "latest" ]; then
  version=$(cat versions | sort -n | tail -n 1 | awk -F, '{ print $1 }')
fi

roswell_version=$(cat versions | grep "$version," | head -n 1 | awk -F, '{ print $2 }')

if [ "$roswell_version" == "" ]; then
  echo "Error: Version not found: $version"
  exit 1
fi

echo "ROSWELL_VERSION=$roswell_version"

tagname="$owner/sbcl:$version-$os"

tag_options="-t $tagname"
if [ "$os" == "debian" ]; then
  tag_options="$tag_options -t $owner/sbcl:$version"
fi
latest_version=$(basename $(cat versions | awk -F, '{ print $1 }' | sort -Vr | head -n 1))
if [ "$latest_version" == "$version" ]; then
  tag_options="$tag_options -t $owner/sbcl:latest-$os"
  if [ "$os" == "debian" ]; then
    tag_options="$tag_options -t $owner/sbcl:latest"
  fi
fi

echo "Build $tagname"
docker buildx build $tag_options \
  $build_args \
  --platform "$arch" \
  --build-arg ROSWELL_IMAGE="$owner/roswell" \
  --build-arg ROSWELL_VERSION=$roswell_version \
  --build-arg OS=$os \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VCS_REF=`git rev-parse --short HEAD` \
  --build-arg VERSION="$version" \
  .

#
# Workaround for the bug of BuildKit which push only the first tag
# even when there's more than one --tag options.

manifests=$(docker manifest inspect "$tagname" | jq -r -M ".manifests // [] | map(\"$owner/sbcl@\" + .digest) | join(\" \")")
if [ "$manifests" != "" ]; then
  if [ "$os" == "debian" ]; then
    docker manifest create "$owner/sbcl:$version" $manifests
    docker manifest push --purge "$owner/sbcl:$version"
  fi
  if [ "$latest_version" == "$version" ]; then
    docker manifest create "$owner/sbcl:latest-$os" $manifests
    docker manifest push --purge "$owner/sbcl:latest-$os"
    if [ "$os" == "debian" ]; then
      docker manifest create "$owner/sbcl:latest" $manifests
      docker manifest push --purge "$owner/sbcl:latest"
    fi
  fi
fi
