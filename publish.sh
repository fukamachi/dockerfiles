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

echo "Publish $tagname"
docker push $tagname

if [ "$target" == "debian" ]; then
  echo "Publish $owner/$image:$version"
  docker tag $tagname "$owner/$image:$version"
  docker push $owner/$image:$version
fi

if [ "$latest_version" == "$version" ]; then
  echo "Publish $owner/$image:latest-$target"
  docker tag $tagname "$owner/$image:latest-$target"
  docker push $owner/$image:latest-$target
  if [ "$target" == "debian" ]; then
    echo "Publish $owner/$image:latest"
    docker tag $tagname "$owner/$image:latest"
    docker push $owner/$image:latest
  fi
fi
