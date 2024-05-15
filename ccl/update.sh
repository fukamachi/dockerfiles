#!/bin/bash

set -ex

cd `dirname $0`

# Ignore 1.11.8
new_versions=( `curl -s "https://api.github.com/repos/roswell/ccl_bin/releases?per_page=10" | jq -r '.[] | .tag_name' | grep -E '^[0-9\\.]+$' | head -n 3 | grep -v "^\\($(cat versions | awk -F, '{ print $1 }' | sed -e 's/\./\\\\./g' | awk '{ printf "\\\\|%s", $1 }' | cut -b 3-)\\)$" | grep -v '^1\.11\.8$' | sort -V` )

latest_roswell=$(cat ../roswell/versions | sort -Vr | head -n 1 | awk -F, '{ print $1 }')

for version in "${new_versions[@]}"; do
  echo "$version,$latest_roswell" > >(tee -a versions)
done
