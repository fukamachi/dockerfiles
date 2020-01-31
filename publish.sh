#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Invalid number of arguments."
  exit 1
fi

cd `dirname $0`

owner=fukamachi
if [ "$GITHUB_REPOSITORY" ]; then
    owner="${GITHUB_REPOSITORY%/*}"
fi

image=$1

echo "Login to Docker Hub"
echo $DOCKER_HUB_PASSWORD | docker login -u $owner --password-stdin

echo "Publish $owner/$image"
docker push $owner/$image
