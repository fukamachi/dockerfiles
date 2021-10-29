#!/bin/bash

set -ex

cd `dirname $0`

new_versions=( `curl -s https://api.github.com/repos/roswell/sbcl_bin/releases | jq -r '.[] | .tag_name' | sed -e 's/^v//' | grep -v "$(cat versions | awk -F, '{ printf "\\|^%s$", $1 }' | cut -b 3-)" | sort -V` )

latest_roswell=$(cat ../roswell/versions | sort -Vr | head -n 1 | awk -F, '{ print $1 }')

for version in "${new_versions[@]}"; do
  echo "$version,$latest_roswell" > >(tee -a versions)
done
