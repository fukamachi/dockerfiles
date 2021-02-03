#!/bin/bash

set -ex

cd `dirname $0`

build_args=$1

images=( "$@" )
if [ ${#images[@]} -eq 0 ]; then
    images=( */ )
fi
images=( "${images[@]%/}" )

for image in "${images[@]}"; do
    ./$image/update.sh $build_args
    ./generate-readme.sh $image > $image/README.md
done
