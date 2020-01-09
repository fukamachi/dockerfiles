#!/bin/bash

cd `dirname $0`

owner=fukamachi

curl -s https://api.github.com/repos/roswell/sbcl_bin/releases | jq -r '.[] | .tag_name' | sed -e 's/^v//' | cat versions - | sort -V | uniq > versions

roswellDebianTag=$(basename $(cat ../roswell/versions | sort -Vr | head -n 1))
roswellAlpineTag="$roswellDebianTag-alpine"

sed -e 's/%%OWNER%%/'"$owner"'/g' \
    -e 's/%%ROSWELL_TAG%%/'"$roswellDebianTag"'/g' \
    debian/Dockerfile.template > debian/Dockerfile

sed -e 's/%%OWNER%%/'"$owner"'/g' \
    -e 's/%%ROSWELL_TAG%%/'"$roswellAlpineTag"'/g' \
    alpine/Dockerfile.template > alpine/Dockerfile
