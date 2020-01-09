#!/bin/bash

cd `dirname $0`

base="fukamachi/roswell"

curl -s https://api.github.com/repos/roswell/sbcl_bin/releases | jq -r '.[] | .tag_name' | sed -e 's/^v//' | cat versions - | sort -V | uniq > versions

latestRoswell=$(basename $(cat ../roswell/versions | sort -Vr | head -n 1))
roswellDebianTag="$latestRoswell-debian"
roswellAlpineTag="$latestRoswell-alpine"

sed -e 's:%%BASE%%:'"$base"':g' \
    -e 's/%%BASE_TAG%%/'"$roswellDebianTag"'/g' \
    Dockerfile.template > debian/Dockerfile

sed -e 's:%%BASE%%:'"$base"':g' \
    -e 's/%%BASE_TAG%%/'"$roswellAlpineTag"'/g' \
    Dockerfile.template > alpine/Dockerfile
