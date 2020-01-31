#!/bin/bash

cd `dirname $0`

new_versions=( `curl -s https://api.github.com/repos/roswell/sbcl_bin/releases | jq -r '.[] | .tag_name' | sed -e 's/^v//' | grep -v "^$(cat versions | awk -F, '{ print $1 }')$" | sort -V` )

latest_roswell=$(cat ../roswell/versions | sort -Vr | head -n 1 | awk -F, '{ print $1 }')

targets=("debian" "alpine" "ubuntu")

for version in "${new_versions[@]}"; do
  echo "New SBCL version found: $version"
  echo "$version,$latest_roswell" >> versions
  for target in "${targets[@]}"; do
    ./build.sh $version $target
    ../test.sh sbcl $version $target
  done
done
