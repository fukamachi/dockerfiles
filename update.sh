#!/bin/bash

set -eux

cd `dirname $0`

images=( "$@" )
if [ ${#images[@]} -eq 0 ]; then
    images=( */ )
fi
images=( "${images[@]%/}" )

for image in "${images[@]}"; do
    # Skip Clozure CL for now because its Roswell build is broken.
    if [ "$image" != "ccl" ]; then
      ./$image/update.sh
      ./generate-readme.sh $image > $image/README.md
    fi
done
