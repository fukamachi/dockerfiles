#!/bin/bash

cd `dirname $0`

images=( "$@" )
if [ ${#images[@]} -eq 0 ]; then
    images=( */ )
fi
images=( "${images[@]%/}" )

for image in "${images[@]}"; do
    ./$image/update.sh
    ./generate-readme.sh $image > $image/README.md
done

roswell_versions=( `cat roswell/versions` "edge" )
sbcl_versions=( `cat sbcl/versions` )
ccl_versions=( `cat ccl/versions` )

sed -e 's/%%ROSWELL_VERSIONS%%/'"[$(a=$(printf ', "%s"' "${roswell_versions[@]}"); echo ${a:1})]"'/g' \
    -e 's/%%SBCL_VERSIONS%%/'"[$(a=$(printf ', "%s"' "${sbcl_versions[@]}"); echo ${a:1})]"'/g' \
    -e 's/%%CCL_VERSIONS%%/'"[$(a=$(printf ', "%s"' "${ccl_versions[@]}"); echo ${a:1})]"'/g' \
    build-images.yml.template > .github/workflows/build-images.yml
