#!/bin/bash

cd `dirname $0`
BASE_DIR=$(pwd)

images=( "$@" )
if [ ${#images[@]} -eq 0 ]; then
    images=( */ )
fi
images=( "${images[@]%/}" )

targets=("debian" "alpine")

for image in "${images[@]}"; do
    cd "$BASE_DIR/$image"
    versions=( `cat versions` )
    for version in "${versions[@]}"; do
        for target in "${targets[@]}"; do
            echo "Generating .github/workflows/docker-build-$image-$version-$target.yml"
            sed -e 's/%%IMAGE%%/'"$image"'/g' \
                -e 's/%%VERSION%%/'"$version"'/g' \
                -e 's/%%TARGET%%/'"$target"'/g' \
                "$BASE_DIR/build-action-template.yml" > "$BASE_DIR/.github/workflows/docker-build-$image-$version-$target.yml"
        done
    done
done
