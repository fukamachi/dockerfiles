#!/bin/bash

cd `dirname $0`

curl -s https://api.github.com/repos/roswell/roswell/releases\?per_page\=5 | jq -r '.[] | .tag_name' | sed -e 's/^v//' | xargs mkdir -p

versions=( */ )
versions=( "${versions[@]%/}" )
IFS=$'\n'; versions=( $(echo "${versions[*]}" | sort -Vr) ); unset IFS

debianSuite='buster-slim'
alpineVersion='3.10'

for version in "${versions[@]}"; do
    echo "Generating Dockerfiles for $version..."

    sed -e 's/%%DEBIAN_TAG%%/'"$debianSuite"'/g' \
        -e 's/%%ROSWELL_VERSION%%/'"$version"'/g' \
        Dockerfile-debian.template > "$version/Dockerfile"

    mkdir -p "$version/alpine"
    sed -e 's/%%ALPINE_TAG%%/'"$alpineVersion"'/g;' \
        -e 's/%%ROSWELL_VERSION%%/'"$version"'/g;' \
        Dockerfile-alpine.template > "$version/alpine/Dockerfile"
done
