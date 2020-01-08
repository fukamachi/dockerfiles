#!/bin/bash

owner=fukamachi

cd `dirname $0`

curl -s https://api.github.com/repos/roswell/sbcl_bin/releases | jq -r '.[] | .tag_name' | sed -e 's/^v//' | xargs mkdir -p

versions=( */ )
versions=( "${versions[@]%/}" )
IFS=$'\n'; versions=( $(echo "${versions[*]}" | sort -Vr) ); unset IFS

roswellDebianTag='latest'
roswellAlpineTag='latest-alpine'

for version in "${versions[@]}"; do
    echo "Generating Dockerfiles for $version..."

    sed -e 's/%%OWNER%%/'"$owner"'/g' \
        -e 's/%%ROSWELL_TAG%%/'"$roswellDebianTag"'/g' \
        -e 's/%%SBCL_VERSION%%/'"$version"'/g' \
        Dockerfile-debian.template > "$version/Dockerfile"

    mkdir -p "$version/alpine"
    sed -e 's/%%OWNER%%/'"$owner"'/g' \
        -e 's/%%ROSWELL_TAG%%/'"$roswellAlpineTag"'/g;' \
        -e 's/%%SBCL_VERSION%%/'"$version"'/g;' \
        Dockerfile-alpine.template > "$version/alpine/Dockerfile"
done
