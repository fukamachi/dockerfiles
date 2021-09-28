#!/bin/bash

set -eux

usage() {
  echo "Usage: roswell/build.sh <version> <os>"
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

edge_base_image="debian:buster-slim"

case "$version" in
  edge)
    dockerfile=$os/Dockerfile.edge
    base_image=$edge_base_image
    ;;
  latest)
    dockerfile=$os/Dockerfile
    version_row=$(cat versions | sort -n | tail -n 1)
    version=$(echo $version_row | awk -F, '{ print $1 }')
    case "$os" in
      debian)
        image_version=$(echo $version_row | awk -F, '{ print $2 }')
        base_image="debian:$image_version"
        ;;
      alpine)
        image_version=$(echo $version_row | awk -F, '{ print $3 }')
        base_image="frolvlad/alpine-glibc:alpine-$image_version"
        ;;
      ubuntu)
        image_version=$(echo $version_row | awk -F, '{ print $4 }')
        base_image="ubuntu:$image_version"
        ;;
      *)
        echo "Error: Unsupported OS $os"
        exit 1
    esac
    ;;
  *)
    dockerfile=$os/Dockerfile
    version_row=$(cat versions | grep "$version," | head -n 1)
    if [ "$version_row" = "" ]; then
      echo "Error: Unsupported Roswell version '$version'"
      exit 1
    fi
    case "$os" in
      debian)
        image_version=$(echo $version_row | awk -F, '{ print $2 }')
        base_image="debian:$image_version"
        ;;
      alpine)
        image_version=$(echo $version_row | awk -F, '{ print $3 }')
        base_image="frolvlad/alpine-glibc:alpine-$image_version"
        ;;
      ubuntu)
        image_version=$(echo $version_row | awk -F, '{ print $4 }')
        base_image="ubuntu:$image_version"
        ;;
      *)
        echo "Error: Unsupported OS $os"
        exit 1
    esac
    ;;
esac

libcurl=$(echo $version_row | awk -F, '{ print $5 }')
if [ "$version" = "edge" ]; then
  libcurl=libcurl4-gnutls-dev
fi

echo "BASE_IMAGE=$base_image"
echo "LIBCURL=$libcurl"

tagname="$owner/roswell:$version-$os"

tag_options="-t $tagname"
if [ "$os" == "debian" ]; then
  tag_options="$tag_options -t $owner/roswell:$version"
fi
latest_version=$(basename $(cat versions | awk -F, '{ print $1 }' | sort -Vr | head -n 1))
if [ "$latest_version" == "$version" ]; then
  tag_options="$tag_options -t $owner/roswell:latest-$os"
  if [ "$os" == "debian" ]; then
    tag_options="$tag_options -t $owner/roswell:latest"
  fi
fi

echo "Build $tagname"
docker buildx build $tag_options \
  $build_args \
  --platform "$arch" \
  --build-arg BASE_IMAGE=$base_image \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VCS_REF=`git rev-parse --short HEAD` \
  --build-arg VERSION="$version" \
  --build-arg LIBCURL="$libcurl" \
  "$os/" --file "$dockerfile"

#
# Workaround for the bug of BuildKit which push only the first tag
# even when there's more than one --tag options.

if [[ "$build_args" == *"--push"* ]]; then
  manifests=$(docker manifest inspect "$tagname" | jq -r -M ".manifests // [] | map(\"$owner/roswell@\" + .digest) | join(\" \")")
  if [ "$manifests" != "" ]; then
    if [ "$os" == "debian" ]; then
      docker manifest create "$owner/roswell:$version" $manifests
      docker manifest push --purge "$owner/roswell:$version"
    fi
    if [ "$latest_version" == "$version" ]; then
      docker manifest create "$owner/roswell:latest-$os" $manifests
      docker manifest push --purge "$owner/roswell:latest-$os"
      if [ "$os" == "debian" ]; then
        docker manifest create "$owner/roswell:latest" $manifests
        docker manifest push --purge "$owner/roswell:latest"
      fi
    fi
  fi
fi
