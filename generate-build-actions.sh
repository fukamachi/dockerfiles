#!/bin/bash

cd `dirname $0`
BASE_DIR=$(pwd)

owner=fukamachi

images=( "$@" )
if [ ${#images[@]} -eq 0 ]; then
    images=( */ )
fi
images=( "${images[@]%/}" )

for image in "${images[@]}"; do
    cd "$BASE_DIR/$image"
    versions=( */ )
    versions=( "${versions[@]%/}" )
    IFS=$'\n'; versions=( $(echo "${versions[*]}" | sort -Vr) ); unset IFS
    latest=1
    for version in "${versions[@]}"; do
        echo "Generating .github/workflows/docker-build-$image-$version.yml"
        sed -e 's/%%OWNER%%/'"$owner"'/g' \
            -e 's/%%IMAGE%%/'"$image"'/g' \
            -e 's/%%VERSION%%/'"$version"'/g' \
            -e 's/%%LATEST%%/'"$latest"'/g' \
            "$BASE_DIR/build-action-template.yml" > "$BASE_DIR/.github/workflows/docker-build-$image-$version.yml"
        latest=0
    done
done
