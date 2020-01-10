#!/bin/bash

cd `dirname $0`

base="fukamachi/roswell"

curl -s https://api.github.com/repos/roswell/sbcl_bin/releases | jq -r '.[] | .tag_name' | sed -e 's/^v//' | cat versions - | sort -V | uniq > versions

latest_roswell=$(basename $(cat ../roswell/versions | sort -Vr | head -n 1))

targets=("debian" "ubuntu" "alpine")

for target in "${targets[@]}"; do
    sed -e 's:%%BASE%%:'"$base"':g' \
        -e 's/%%BASE_TAG%%/'"$latest_roswell-$target"'/g' \
        Dockerfile.template > $target/Dockerfile
done
