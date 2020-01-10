#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Too few arguments."
  exit 1
fi

cd `dirname $0`

owner=fukamachi
if [ "$GITHUB_REPOSITORY" ]; then
    owner="${GITHUB_REPOSITORY%/*}"
fi

image=$1
version=$2
target=$3

tagname="$owner/$image:$version-$target"
latest_version=$(basename $(cat $image/versions | sort -Vr | head -n 1))

echo "Login to Docker Hub"
echo $DOCKER_HUB_PASSWORD | docker login -u $owner --password-stdin

echo "Create alias tags"
if [ "$target" == "debian" ]; then
  docker tag $tagname "$owner/$image:$version"
fi

if [ "$latest_version" == "$version" ]; then
  docker tag $tagname "$owner/$image:latest-$target"
  if [ "$target" == "debian" ]; then
    docker tag $tagname "$owner/$image:latest"
  fi
fi

echo "Publish $owner/$image"
docker push $owner/$image
