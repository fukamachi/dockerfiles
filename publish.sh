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

function publish_version () {
    version="$1"
    echo "Publishing image of $image:$version..."
    docker push "${OWNER}/${image}:${version}"
}

if [ "$ONLY_NEW_TAGS" ]; then
    docker_token=$(curl -s 'https://auth.docker.io/token?service=registry.docker.io&scope=repository:${OWNER}/${image}:pull' | jq -r '.token')
    exists_tags=( `curl -s -H "Authorization: Bearer $docker_token" https://registry.hub.docker.com/v2/${OWNER}/${image}/tags/list | jq -r '.tags | .[]'` )
fi

for version in "${versions[@]}"; do
    if [[ " ${exists_tags[@]} " =~ " $version " ]]; then
        echo "Skipped $image:$version"
    else
        publish_version "$version"
    fi

    if [[ " ${exists_tags[@]} " =~ " $version-alpine " ]]; then
        echo "Skipped $image:$version-alpine"
    else
        publish_version "$version-alpine"
    fi
done

if [[ " ${exists_tags[@]} " =~ " ${versions[0]} " ]]; then
    echo "Skipped $image:latest"
else
    publish_version "latest"
fi
if [[ " ${exists_tags[@]} " =~ " ${versions[0]}-alpine " ]]; then
    echo "Skipped $image:latest-alpine"
else
    publish_version "latest-alpine"
fi
