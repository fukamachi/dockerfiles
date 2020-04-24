#!/bin/bash

set -eux

cd `dirname $0`

new_versions=( `curl -s "https://api.github.com/repos/roswell/ccl_bin/releases?per_page=10" | jq -r '.[] | .tag_name' | grep -E '^[0-9\\.]+$' | head -n 3 | grep -v "^$(cat versions | awk -F, '{ print $1 }')$" | sort -V` )

latest_roswell=$(cat ../roswell/versions | sort -Vr | head -n 1 | awk -F, '{ print $1 }')

targets=("debian" "alpine" "ubuntu")

for version in "${new_versions[@]}"; do
  echo "New Clozure CL version found: $version"
  echo "$version,$latest_roswell" >> versions
  for target in "${targets[@]}"; do
    ./build.sh $version $target
    ../test.sh ccl $version $target
  done
done
