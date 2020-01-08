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
IFS=$'\n'; versions=( $(echo "${versions[*]}" | sort -Vr) ); unset IFS

for version in "${versions[@]}"; do
    echo "Building image of $image:$version..."
    docker build -t "${OWNER}/${image}:${version}" "$version"
    echo "Building image of $image:$version-alpine..."
    docker build -t "${OWNER}/${image}:${version}-alpine" "$version/alpine"
done

docker tag "${OWNER}/${image}:${versions[0]}" "${OWNER}/${image}:latest"
docker tag "${OWNER}/${image}:${versions[0]}-alpine" "${OWNER}/${image}:latest-alpine"
