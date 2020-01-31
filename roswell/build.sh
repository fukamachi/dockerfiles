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

edge_base_image="debian:buster-slim"

if [ "$version" == "edge" ]; then
  dockerfile=$target/Dockerfile.edge
  base_image=$edge_base_image
else
  dockerfile=$target/Dockerfile
  version_row=$(cat versions | grep "$version," | head -n 1)
  case "$target" in
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
      echo "Unsupported target $target"
      exit 1
  esac
fi

echo "BASE_IMAGE=$base_image"

tagname="$owner/roswell:$version-$target"

echo "Build $tagname"
docker build -t $tagname \
  --build-arg BASE_IMAGE=$base_image \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VCS_REF=`git rev-parse --short HEAD` \
  --build-arg VERSION="$version" \
  $target/ --file $dockerfile

echo "Create alias tags"
if [ "$target" == "debian" ]; then
  docker tag $tagname "$owner/roswell:$version"
fi

latest_version=$(basename $(cat versions | awk -F, '{ print $1 }' | sort -Vr | head -n 1))
if [ "$latest_version" == "$version" ]; then
  docker tag $tagname "$owner/roswell:latest-$target"
  if [ "$target" == "debian" ]; then
    docker tag $tagname "$owner/roswell:latest"
  fi
fi
