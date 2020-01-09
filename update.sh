#!/bin/bash

cd `dirname $0`

images=( "$@" )
if [ ${#images[@]} -eq 0 ]; then
    images=( */ )
fi
images=( "${images[@]%/}" )

for image in "${images[@]}"; do
    ./$image/update.sh
done

roswell_versions=( `cat roswell/versions` )
sbcl_versions=( `cat sbcl/versions` )

sed -e 's/%%ROSWELL_VERSIONS%%/'"[$(IFS=,; echo "${roswell_versions[*]}")]"'/g' \
    -e 's/%%SBCL_VERSIONS%%/'"[$(IFS=,; echo "${sbcl_versions[*]}")]"'/g' \
    build-images.yml.template > .github/workflows/build-images.yml
