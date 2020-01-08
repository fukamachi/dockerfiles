#!/bin/bash

OWNER=fukamachi

image="$@"

if [ "$image" == "" ]; then
    echo "No image name is given."
    exit -1
fi

if [ ! -d "$image" ]; then
    echo "Invalid image name: ${image}"
    exit -1
fi

cd $image

image=$(basename `pwd`)

versions=( */ )
versions=( "${versions[@]%/}" )
IFS=$'\n'; versions=( $(echo "${versions[*]}" | sort -V) ); unset IFS

for version in "${versions[@]}"; do
    echo "Publishing image of $image:$version..."
    docker push "${OWNER}/${image}:${version}"
    echo "Publishing image of $image:$version-alpine..."
    docker push "${OWNER}/${image}:${version}-alpine"
done

echo "Publishing image of $image:latest..."
docker push "${OWNER}/${image}:latest"
echo "Publishing image of $image:latest-alpine..."
docker push "${OWNER}/${image}:latest-alpine"
